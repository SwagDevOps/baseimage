# frozen_string_literal: true

require_relative '../boot'

# Simple thread pool.
#
# ThreadPool avoid runing more than exepected threads at once
# (max pools size is configurable),
# and waits unil all threads are terminated.
class Boot::ThreadPool
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  def initialize(**options)
    @jobs = []
    @pools_size = options[:pools_size] || cpuinfo.fetch(:siblings, 1) + 1

    yield(self) if block_given?
    (options.key?(:auto_start) ? options[:auto_start] : true).tap do |b|
      call if b
    end
  end

  def schedule(&block)
    jobs.push(block)
  end

  # @see ThreadPool.cpuinfo
  #
  # @return [Hash{Symbol => String}]
  def cpuinfo
    @cpuinfo ||= self.class.cpuinfo
  end

  # @return [Array<Thread>]
  def call
    self.run
  end

  class << self
    # rubocop:disable Metrics/AbcSize

    # Get CPU Info in Linux
    #
    # The simplest way to determine what type of CPU you have,
    # is by displaying the contents of the ``/proc/cpuinfo`` virtual file.
    # Identifying the type of processor using the ``proc/cpuinfo`` file does not
    # require installing any additional programs.
    # It will work no matter what Linux distribution you are using.
    #
    # @return [Hash{Symbol => String|Fixnum}]
    def cpuinfo
      Pathname.new('/proc/cpuinfo').read.strip.lines.map do |line|
        # @formatter:off
        [
          line.split(':')[0].strip.downcase.gsub(/\W+/, '_').to_sym,
          line.split(':')[1..-1].join(':').strip
        ]
        # @formatter:on
      end.reject { |k, _v| k.to_s.empty? }.map do |k, v|
        [k, YAML.safe_load(v)]
      rescue StandardError
        [k, v]
      end.to_h
    end
  end

  # rubocop:enable Metrics/AbcSize

  protected

  # Jobs to execute/process.
  #
  # @return [Array<Proc>]
  attr_accessor :jobs

  # Size for pools.
  #
  # @retrun [Integer]
  attr_accessor :pools_size

  # Execute scheduled jobs by pools.
  #
  # @return [Array<Thread>]
  def run
    [].tap do |pool|
      until jobs.empty?
        jobs.shift(pools_size).each do |job|
          thread(&job).tap { |thread| pool.push(thread) }
        end

        sleep(0.0001) while pool.map(&:alive?).include?(true)
      end
    end
  end

  # Execute given block as thread.
  #
  # If any thread is aborted by an exception,
  # the raised exception will be re-raised in the main thread.
  #
  # @return [Thread]
  def thread(&block)
    Thread.new do
      Thread.current.abort_on_exception = true

      block.call
    end
  end
end

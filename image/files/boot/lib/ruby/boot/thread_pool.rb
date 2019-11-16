# frozen_string_literal: true

require_relative '../boot'

# Simple thread pool.
#
# ThreadPool avoid runing more than exepected threads at once
# (max pools size is configurable),
# and waits unil all threads are terminated.
class Boot::ThreadPool
  # @formatter:off
  {
    CpuInfo: 'cpu_info',
    Runner: 'runner',
    SafeThread: 'safe_thread',
  }.each { |s, fp| autoload(s, "#{__dir__}/thread_pool/#{fp}") }
  # @formatter:on

  def initialize(**options)
    @jobs = Queue.new
    @pool = Runner.new(*[options[:pools_size]].compact)

    yield(self) if block_given?
    (options.key?(:auto_start) ? options[:auto_start] : true).tap do |b|
      call if b
    end
  end

  def schedule(&block)
    jobs.push(block)
  end

  # @return [Array<Thread>]
  def call
    self.run
  end

  protected

  # Pool runner.
  #
  # @return [Runner]
  attr_accessor :pool

  # Jobs to execute/process.
  #
  # @return [Queue<Proc>]
  attr_accessor :jobs

  # Execute scheduled jobs.
  def run
    # rubocop:disable Style/WhileUntilModifier
    pool.to_a.tap do
      while pool.alive? or !jobs.empty?
        statements.each(&:call)
      end
    end
    # rubocop:enable Style/WhileUntilModifier
  end

  # Statements used during `run`.
  #
  # @return [Array<Proc>]
  def statements
    available_statements.keep_if { |_m, v| v }.keys
  end

  # @return [Hash{Proc => Boolean}]
  def available_statements
    # @formatter:off
    {
      -> { pool.push(jobs.shift) if pool.ready? } => !jobs.empty?,
      -> { sleep(1.0 / 100_000) } => pool.alive?,
    }
    # @formatter:on
  end
end

# frozen_string_literal: true

require_relative '../thread_pool'

# Get CPU Info in Linux
#
# The simplest way to determine what type of CPU you have,
# is by displaying the contents of the ``/proc/cpuinfo`` virtual file.
# Identifying the type of processor using the ``proc/cpuinfo`` file does not
# require installing any additional programs.
# It will work no matter what Linux distribution you are using.
class Boot::ThreadPool::CpuInfo < Hash
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  def initialize
    self.class.cpuinfo.each { |k, v| self[k] = v }
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
    # rubocop:enable Metrics/AbcSize
  end
end

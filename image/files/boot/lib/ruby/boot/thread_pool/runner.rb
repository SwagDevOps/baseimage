# frozen_string_literal: true

require_relative '../thread_pool'

# Simple thread pool.
#
# ThreadPool avoid runing more than exepected threads at once
# (max pools size is configurable),
# and waits unil all threads are terminated.
class Boot::ThreadPool::Runner < Array
  # @param [Fixnum] max_run
  def initialize(max_run = nil)
    @mutex = Mutex.new
    @max_run = max_run || cpu_info.fetch(:siblings, 1) + 1

    super([])
  end

  # Denote runner is ready to receive a new process to run.
  #
  # @return [Boolean]
  def ready?
    num_alive < @max_run
  end

  # Get count for alive threads.
  #
  # @return [Fixnum]
  def num_alive
    self.map(&:alive?).keep_if { |v| v == true }.size
  end

  # @return [Boolean]
  def alive?
    # rubocop:disable Style/NumericPredicate
    num_alive > 0
    # rubocop:enable Style/NumericPredicate
  end

  # Get executed threads.
  #
  # @return [Array<Thread>]
  def done
    self.reject(&:alive?)
  end

  # @param [Proc] callable
  #
  # @return [self]
  # @todo raise error if push on a non ready runner.
  def push(callable)
    self.tap do
      @mutex.synchronize do
        thread(&callable).tap { |thread| super(thread) }
      end
    end
  end

  protected

  # Execute given block as thread.
  #
  # If any thread is aborted by an exception,
  # the raised exception will be re-raised in the main thread.
  #
  # @return [Thread]
  def thread(&block)
    Boot::ThreadPool::SafeThread.new(&block)
  end

  # Get CPU information.
  #
  # @return [CpuInfo|Hash]
  def cpu_info
    Boot::ThreadPool::CpuInfo.new
  end
end

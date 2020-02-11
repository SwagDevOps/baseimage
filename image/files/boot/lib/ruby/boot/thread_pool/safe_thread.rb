# frozen_string_literal: true

# Thread providing exceptions handling
#
# @see https://stackoverflow.com/questions/9095316/handling-exceptions-raised-in-a-ruby-thread
class Boot::ThreadPool::SafeThread < ::Thread
  def initialize(*args, &block)
    # rubocop:disable Lint/RescueException
    super(*args) do
      block.call
    rescue Exception => e
      self.postponed_exception = e
    end
    # rubocop:enable Lint/RescueException
  end

  def join
    raise_postponed_exception
    super.tap(&:raise_postponed_exception)
  end

  protected

  # @return [Exception|nil]
  attr_accessor :postponed_exception

  # Denote has postponed exception.
  #
  # @return [Boolean]
  def postponed_exception?
    postponed_exception.is_a?(Exception)
  end

  # @raise [Exception]
  def raise_postponed_exception
    Thread.main.raise(postponed_exception) if postponed_exception?
  end
end

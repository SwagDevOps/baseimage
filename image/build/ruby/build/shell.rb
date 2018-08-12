# frozen_string_literal: true

require_relative '../build'

# Provide sh method.
module Build::Shell
  autoload :Shellwords, 'shellwords'

  singleton_class.include(self)

  protected

  def sh(*cmd)
    require 'English'

    cmd.compact.map(&:to_s).tap do |command|
      warn(command.size == 1 ? command : Shellwords.join(command))

      system(*command)
        .tap { |res| exit($CHILD_STATUS.exitstatus) unless res }
    end
  end
end

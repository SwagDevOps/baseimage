# frozen_string_literal: true

require 'serverspec/type/file'
require 'serverspec/type/command'

class Serverspec::Type::File
  autoload(:Shellwords, 'shellwords')

  # @return [Boolean]
  def empty?
    # @formatter:off
    {
      true => ->(cmd) { cmd.exit_status.zero? and cmd.stdout.empty? },
      false => ->(cmd) { cmd.exit_status.zero? }
    }.fetch(self.directory?).call(commamnd_for_empty)
    # @formatter:on
  end

  protected

  # @return [Serverspec::Type::Command.new(]
  def commamnd_for_empty
    # @formatter:off
    {
      true => ['ls', '-A', self.name],
      false => ['test', '-s', self.name]
    }.map do |k, v|
      [k, Serverspec::Type::Command.new(Shellwords.join(v))]
    end.to_h.fetch(self.directory?)
    # @formatter:on
  end
end

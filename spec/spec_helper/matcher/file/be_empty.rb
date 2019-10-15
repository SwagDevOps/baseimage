# frozen_string_literal: true

RSpec::Matchers.define(:be_empty) do
  match do |file|
    [file.class.to_s.split('::').last, file.name].tap do |type, fname|
      "expected #{type} #{fname.inspect} to respond to `empty?`".tap do |msg|
        raise msg unless file.is_a?(Serverspec::Type::File)
      end
    end

    return false unless file.exists?

    autoload(:Shellwords, 'shellwords')
    # @formatter:off
    command = {
      true => ['ls', '-A', file.name],
      false => ['test', '-s', file.name]
    }.map do |k, v|
      [k, Serverspec::Type::Command.new(Shellwords.join(v))]
    end.to_h.fetch(file.directory?)

    {
      true => ->(cmd) { cmd.exit_status.zero? and cmd.stdout.empty? },
      false => ->(cmd) { cmd.exit_status.zero? }
    }.fetch(file.directory?).call(command)
    # @formatter:on
  end
end

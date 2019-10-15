# frozen_string_literal: true

RSpec::Matchers.define :be_empty do
  autoload(:Shellwords, 'shellwords')

  match do |file|
    Serverspec::Type::File.tap do |type|
      "expected #{file.class.to_s.split('::').last} #{file.name.inspect} to respond to `empty?`".tap do |msg|
        raise msg unless file.is_a?(type)
      end
    end

    # @formatter:off
    args = Shellwords.join({
      true => ['ls', '-A', file.name],
      false => ['test', '-s', file.name]
    }.fetch(file.directory?))
    # @formatter:on
    command = Serverspec::Type::Command.new(args)
    file.directory? ? command.stdout.empty? : command.exit_status.zero?
  end
end

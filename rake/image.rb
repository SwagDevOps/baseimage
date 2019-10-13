# frozen_string_literal: true

require 'kamaze/version'
require 'kamaze/docker_image'

autoload(:YAML, 'yaml')

# rubocop:disable Metrics/BlockLength
Kamaze::DockerImage.new do |config|
  config.version = Kamaze::Version.new('image/version.yml').freeze
  config.path = 'image'
  config.verbose = false
  # @formatter:off
  config.ssh = lambda do
    { enabled: true }.tap do |c|
      Pathname.new(__dir__).join('config/ssh.yml').tap do |file|
        return YAML.safe_load(file.read, [Symbol]).merge(c) if file.file?
      end
    end
  end.call
  config.name = [
    lambda do
      Pathname.new(__dir__).join('config/registries.yml').tap do |file|
        if file.file? and ENV.key?('registry')
          YAML.safe_load(file.read).tap { |h| return h.fetch(ENV['registry']) }
        end
      end

      ENV['registry']
    end.call,
    ENV.fetch('image_name'),
  ].compact.join('/')
  # @formatter:on
  config.run_as = [ENV.fetch('image_name'), ENV['registry']].compact.join('.')

  # @formatter:off
  config.commands.merge!(
    stop: ['stop', '-t', 20, '%<run_as>s'],
    start: ['run', '-h', config.run_as,
            '-v', "#{Dir.pwd}/ssh/:/boot/ssh",
            '-d', '--name', '%<run_as>s', '%<tag>s']
  )
  # @formatter:on
end.tap do |image|
  # noinspection RubyBlockToMethodReference
  singleton_class.__send__(:define_method, :image) { image }
end
# rubocop:enable Metrics/BlockLength

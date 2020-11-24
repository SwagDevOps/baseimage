# frozen_string_literal: true

require 'kamaze/version'
require 'kamaze/docker_image'

autoload(:YAML, 'yaml')

# rubocop:disable Metrics/BlockLength
Kamaze::DockerImage.new do |config|
  config.path = 'image'
  config.version = Kamaze::Version.new("#{config.path}/version.yml").freeze
  config.verbose = ENV.fetch('verbose', 'false').yield_self { |v| YAML.safe_load(v) }
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
        if !ENV['registry'].to_s.empty? and file.file?
          YAML.safe_load(file.read).tap { |h| return h.fetch(ENV['registry']) }
        end
      end

      ENV['registry']
    end.call,
    ENV.fetch('image_name'),
  ].compact.join('/')
  config.run_as = ENV.fetch('image_name').split('/').reverse
                     .concat([ENV['registry']].compact.reject(&:empty?))
                     .join('.')

  config.commands.merge!(
    stop: ['stop', '-t', 20, '%<run_as>s'],
    start: ['run', '-h', config.run_as,
            '-v', "#{Dir.pwd}/ssh/:/boot/ssh",
            '-d', '--name', '%<run_as>s', '%<tag>s']
  )
  # @formatter:on
  config.tasks_load = !self.respond_to?(:image)
end.tap do |image|
  # noinspection RubyBlockToMethodReference
  singleton_class.__send__(:define_method, :image) { image }

  image.singleton_class.__send__(:define_method, :vendor) do
    Pathname.new("#{image.path}/build/vendor")
  end

  image.singleton_class.__send__(:define_method, :dockerfile) do
    Pathname.new("#{image.path}/Dockerfile")
  end
end
# rubocop:enable Metrics/BlockLength

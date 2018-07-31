# frozen_string_literal: true

require 'kamaze/version'
require 'kamaze/docker_image'

Kamaze::DockerImage.new do |config|
  config.name    = 'kamaze/alpine_server'
  config.version = Kamaze::Version.new('image/version.yml').freeze
  config.path    = 'image'
  config.verbose = false
  config.run_as  = File.basename(config.name)
  config.ssh     = { enabled: true }

  config.commands.merge!(
    stop: ['stop', '-t', 20, '%<run_as>s'],
    start: ['run', '-h', config.run_as,
            '-v', "#{Dir.pwd}/ssh/:/etc/dropbear",
            '-d', '--name', '%<run_as>s', '%<tag>s']
  )
end.tap do |image|
  singleton_class.__send__(:define_method, :image) { image }
end

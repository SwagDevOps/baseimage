require 'rubygems'
require 'bundler/setup'
require 'kamaze/docker_image'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze::DockerImage.new do |config|
  config.name    = 'kamaze/alpine_server'
  config.version = '0.0.1'

  config.path    = "#{Dir.pwd}/image"
  config.verbose = false
  config.run_as  = File.basename(config.name)

  config.commands.merge!(
    start: ['run', '-h', config.run_as,
            '-d', '--name', '%<run_as>s', '%<tag>s']
  )
end

task default: [:build]

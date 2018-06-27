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
  config.run_as  = '%s_dev' % config.name.tr('/', '_')
end

task default: [:build]

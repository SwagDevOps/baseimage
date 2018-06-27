require 'rubygems'
require 'bundler/setup'
require 'kamaze/docker_image'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze::DockerImage.new do |image|
  image.name     = 'kamaze/alpine_server'
  image.version  = '0.0.1'
  image.path     = "#{Dir.pwd}/image"
  image.run_as   = '%s_dev' % image.name.tr('/', '_')
end

task default: [:build]

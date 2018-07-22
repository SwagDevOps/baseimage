# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

require 'rubygems'
require 'bundler/setup'
require 'kamaze/docker_image'
require 'sys/proc'

autoload :Vendorer, 'vendorer'

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

task 'pre_build' do
  Vendorer.new(update: false).tap do |v|
    config_locations = ['Vendorfile.rb', 'Vendorfile']
    config_location = config_locations.detect { |f| File.exist?(f) }

    v.parse(File.read(config_location || config.locations.last))
  end
end

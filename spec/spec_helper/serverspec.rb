# frozen_string_literal: true

require 'serverspec'
require 'net/ssh'
require_relative 'image'

image.ssh_runner.wait.network.fetch(0).tap do |host|
  options = {
    user_known_hosts_file: '/dev/null',
    user: 'root'
  }.merge(Net::SSH::Config.for(host))

  set :backend, :ssh
  set :os, family: :alpine
  set :host,         host
  set :ssh_options,  options
  set :disable_sudo, true
  set :path, '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
end

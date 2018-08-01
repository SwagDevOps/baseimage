# frozen_string_literal: true

require 'serverspec'
require 'net/ssh'
require_relative 'image'

set :backend, :ssh

image.ssh_runner.wait.network.fetch(0).tap do |host|
  options = {
    user_known_hosts_file: '/dev/null',
    user: 'root'
  }.merge(Net::SSH::Config.for(host))

  set :host,         host
  set :ssh_options,  options
  set :disable_sudo, true
end

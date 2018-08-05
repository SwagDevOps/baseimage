# frozen_string_literal: true

require_relative 'image'
require 'serverspec'
require 'net/ssh'

image.ssh.wait.network.fetch(0).tap do |host|
  set :backend, :ssh
  set :os, family: :alpine
  set :host, host
  set :disable_sudo, true
  set :path, '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
  set :ssh_options, Net::SSH::Config.for(host).merge(
    user_known_hosts_file: '/dev/null',
    user: image.ssh.fetch(:user),
    port: image.ssh.fetch(:port)
  )
end

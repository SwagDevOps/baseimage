# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

require 'rubygems'
require 'bundler/setup'

require 'sys/proc'

Sys::Proc.progname = nil

Dir.chdir(__dir__) do
  require_relative 'rake/image'
  require_relative 'rake/project'
  require_relative 'rake/build'
end

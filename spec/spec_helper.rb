# frozen_string_literal: true

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rspec'
end

require 'rbconfig'
require_relative 'spec_helper/alpine_version'
require_relative 'spec_helper/serverspec'

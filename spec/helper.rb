# frozen_string_literal: true

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'serverspec'
end

# noinspection RubyResolve
require 'rbconfig'

# @formatter:off
# noinspection RubyResolve
# noinspection RubyLiteralArrayInspection
[
  'image',
  'alpine_version',
  'image_version',
  'serverspec',
  'monkey_patch',
  'matcher'
].each { |fname| require("#{__FILE__.gsub(/\.rb$/, '')}/#{fname}") }
# @formatter:on

# frozen_string_literal: true

# noinspection RubyResolve
require 'rbconfig'
# noinspection RubyResolve
require 'serverspec'

# @formatter:off
# noinspection RubyResolve
# noinspection RubyLiteralArrayInspection
[
  'env',
  'image',
  'alpine_version',
  'image_version',
  'serverspec',
  'monkey_patch',
  'matcher'
].each { |fname| require("#{__FILE__.gsub(/\.rb$/, '')}/#{fname}") }
# @formatter:on

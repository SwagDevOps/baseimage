# frozen_string_literal: true

require_relative '../boot'

# Almost a namespace.
module Boot::Dropbear
  autoload(:Pathname, 'pathname')

  # @formatter:off
  {
    Setup: 'setup',
  }.each { |s, fp| autoload(s, Pathname.new(__dir__).join("dropbear/#{fp}")) }
  # @formatter:on
end

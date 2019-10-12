# frozen_string_literal: true

require_relative 'image'
autoload(:Pathname, 'pathname')
autoload(:YAML, 'yaml')

# Current Image version.
#
# @type [Hash{String => String|Fixnum}]
IMAGE_VERSION = lambda do
  image.version.file.realpath.read.tap do |s|
    return YAML.safe_load(s)
  end
end.call

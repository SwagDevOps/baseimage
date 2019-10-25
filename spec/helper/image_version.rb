# frozen_string_literal: true

require_relative 'image'
autoload(:YAML, 'yaml')

# Current Image version.
#
# @type [Hash{String => String|Fixnum}]
IMAGE_VERSION = lambda do
  image.version.file.realpath.read.tap do |s|
    YAML.safe_load(s).tap do |version|
      version.singleton_class.__send__(:define_method, :to_s) do
        [version['major'], version['minor'], version['patch']].join('.').freeze
      end
    end.tap { |version| return version.freeze }
  end
end.call

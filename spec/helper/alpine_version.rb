# frozen_string_literal: true

autoload(:Pathname, 'pathname')

# Current Alpine version, based on (generated) Dockerfile.
#
# @type [String]
ALPINE_VERSION = lambda do
  # @formatter:off
  Pathname.new(Dir.pwd)
          .join('image/Dockerfile')
          .read.scan(/^FROM ["]{0,1}alpine:((?:[0-9]+\.){2}[0-9]+)["]{0,1}$/)
          .fetch(0).fetch(0).freeze
  # @formatter:on
end.call.freeze

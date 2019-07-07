# frozen_string_literal: true

# Current Alpine version, based on (generated) Dockerfile.
#
# @type [String]
ALPINE_VERSION = proc do
  # @formatter:off
  Pathname.new(Dir.pwd)
          .join('image/Dockerfile')
          .read.scan(/^FROM alpine:((?:[0-9]+\.){2}[0-9]+)$/)
          .fetch(0).fetch(0).freeze
  # @formatter:on
end.call

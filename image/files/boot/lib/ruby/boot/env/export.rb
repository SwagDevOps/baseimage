# frozen_string_literal: true

require_relative '../env'

# Provides environment export.
class Boot::Env::Export < Hash
  autoload(:Shellwords, 'shellwords')
  autoload(:Pathname, 'pathname')

  # @param [ENV|Hash] env
  def initialize(env = ENV)
    env.clone.to_h.sort.to_h.each do |k, v|
      self[k] = v
    end
  end

  # @return [String]
  def to_s
    self.map { |k, v| "#{k}=#{Shellwords.escape(v)}\n" }.join
  end

  # Environment formatted, with ``export``.
  #
  # @return [String]
  def export
    to_s.lines.map { |line| "export #{line}" }.join
  end

  # Get string representation followed by the content of given file.
  #
  # @return [String]
  def append(filepath, format = :to_s)
    # @formatter:off
    [
      self.public_send(format),
      Pathname.new(filepath).read.lstrip,
    ].join("\n")
    # @formatter:on
  end

  # Get string representation preceded by the content of given file.
  #
  # @return [String]
  def prepend(filepath, format = :to_s)
    # @formatter:off
    [
      Pathname.new(filepath).read.rstrip,
      self.public_send(format),
    ].join("\n")
    # @formatter:on
  end
end

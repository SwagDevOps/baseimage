# coding: utf-8
# frozen_string_literal: true

require_relative '../ssh'

# Install files found in `authorized_keys` into users home.
#
# Sample directory structure:
#
# ```
# /boot/ssh/
# └── authorized_keys
#     └── root
# ```
class Boot::SSH::Auth
  autoload(:Etc, 'etc')
  autoload(:Pathname, 'pathname')
  autoload(:FileUtils, 'fileutils')
  # noinspection RubyResolve
  include(FileUtils::Verbose)

  def initialize(path = '/boot/ssh/authorized_keys')
    @path = Pathname.new(path)
    @errors = []
  end

  def call
    self.processables.tap do |processables|
      # noinspection RubyBlockToMethodReference
      self.errors.each { |e| warn(e) }
      processables.each { |file, user| self.install_key(file, user) }
    end
  end

  # @param [String] file
  # @param [Struct|Etc::Passwd] user
  # @return [Pathname]
  def install_key(file, user)
    Pathname.new("#{user.dir}/.ssh/authorized_keys").tap do |target|
      mkdir_p(target.dirname)
      chmod(0o700, target.dirname)
      cp(file, target)
      chmod(0o400, target)
      chown(user.uid, user.gid, target) if user
    end
  end

  # Get auth files and users.
  #
  # @return [Hash{Pathname => Struct}]
  def processables
    # @formatter:off
    Dir["#{self.path}/{.[^\.]*,*}"]
      .sort
      .map { |f| Pathname.new(f) }.keep_if(&:file?).map do |file|
      [file, Etc.getpwnam(file.basename.to_s)]
    rescue ArgumentError => e
      self.errors.push(e)
    end.compact.keep_if { |_file, user| user.respond_to?(:dir) }.to_h
    # @formatter:off
  end

  protected

  # Get path used to retrieve `authorized_keys` files.
  #
  # @return [Pathname]
  attr_reader :path

  # @return [Array<Exception>]
  attr_reader :errors
end

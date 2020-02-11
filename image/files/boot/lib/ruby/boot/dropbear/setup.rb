# coding: utf-8
# frozen_string_literal: true

require_relative '../ssh'

# Generate (as required) and install hostkey.
#
# When a (openssh) PEM file is present, it will be used to generate
# a RSA (dropbear) key. Instead, if a RSA file is present, it will be used.
# Hostkey already present will be overwritten by the result of this script.
class Boot::Dropbear::Setup
  autoload(:Pathname, 'pathname')
  autoload(:FileUtils, 'fileutils')
  include(FileUtils::Verbose)

  # @formatter:off
  BOOT_FILES = {
    'pem': 'host_rsa.pem',
    'rsa': 'host_rsa',
  }.map { |key, name| [key, Pathname.new('/boot/ssh').join(name)] }.to_h.freeze
  # @formatter:on

  def initialize(confdir = ENV['DROPBEAR_CONFDIR'])
    @confdir = Pathname.new(confdir || '/etc/dropbear')
  end

  # Directories used during boot sequence.
  #
  # @return [Array<Pathname>]
  def boot_directories
    BOOT_FILES.to_a.map { |_k, file| file.dirname }.uniq
  end

  # Generate host file and intall it.
  def call
    make_directories

    confdir.join('host_rsa').tap do |host_rsa|
      (BOOT_FILES[:pem].file? ? :mv : :cp).tap do |m|
        # move host_rsa when PEM file is present
        # because host_rsa has been generetaed from PEM file.
        self.__send__(m, gen_key.to_s, host_rsa.to_s)
      end
      chmod(0o400, host_rsa.to_s)
    end
  end

  protected

  attr_reader :confdir

  # Execute given args as a command line.
  #
  # @raise [RuntimeError]
  def sh(*args)
    system(*args) || lambda do
      raise args.inspect
    end.call
  end

  # Convert PEM file
  #
  # @return [Array<Pathname>]
  def pem_convert
    [BOOT_FILES.fetch(:pem), BOOT_FILES.fetch(:rsa)].tap do |files|
      if files[0].file?
        sh('dropbearconvert',
           'openssh',
           'dropbear',
           files[0].to_s, files[1].to_s)
      end
    end
  end

  # Generate server key.
  #
  # @return [Pathname]
  def gen_key
    BOOT_FILES.fetch(:rsa).tap do |rsa|
      pem_convert

      sh('dropbearkey', '-f', rsa.to_s, '-t', 'rsa') unless rsa.file?
    end
  end

  # Create required directories
  #
  # @return [self]
  def make_directories
    self.tap do
      Boot::ThreadPool.new do |pool|
        boot_directories.clone.push(confdir).map do |fp|
          pool.schedule { mkdir_p(fp.to_s) unless fp.exist? }
        end
      end
    end
  end
end

# coding: utf-8
# frozen_string_literal: true

require_relative '../ssh'

# Generate (as required) and install hostkey.
#
# When a (openssh) PEM file is present, it will be used to generate
# a RSA (dropbear) key. Instead, if a RSA file is present, it will be used.
# Hostkey already present will be overwritten by the result of this script.
class Boot::Dropbear::Setup
  autoload(:FileUtils, 'fileutils')
  autoload(:Pathname, 'pathname')
  autoload(:OpenSSL, 'openssl')

  PEM_TYPES = [:EC, :RSA, :DSA]

  # @formatter:off
  BOOT_FILES = {
      'pem': 'host.pem',
      'key': 'host.key',
  }.map { |key, name| [key, Pathname.new('/boot/ssh').join(name)] }.to_h.freeze
  # @formatter:on

  def initialize(confdir: ENV['DROPBEAR_CONFDIR'], verbose: true)
    @confdir = Pathname.new(confdir || '/etc/dropbear')
    @fs = verbose ? FileUtils::Verbose : FileUtils
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

    confdir.join('host.key').tap do |host_key|
      (BOOT_FILES.fetch(:pem).file? ? :mv : :cp).tap do |m|
        # move host.key when PEM file is present
        # because host.key has been generetaed from PEM file.
        fs.__send__(m, gen_key.to_s, host_key.to_s)
      end
      fs.chmod(0o400, host_key.to_s)
    end
  end

  protected

  attr_reader :confdir

  # @return [FileUtils::Verbose|FileUtils]
  attr_reader :fs

  # Execute given args as a command line.
  #
  # @raise [RuntimeError]
  def sh(*args)
    system(*args) || lambda do
      raise args.inspect
    end.call
  end

  # @param [Pathname] file
  # @raise [OpenSSL::PKey::PKeyError]
  #
  # @return [OpenSSL::PKey::EC|OpenSSL::PKey::RSA|OpenSSL::PKey::DSA]
  def pem_detect(file)
    lambda do
      nil.tap do
        PEM_TYPES.each do |type|
          return OpenSSL::PKey.const_get(type).new(file.read)
        rescue OpenSSL::PKey::PKeyError
          warn("Key (#{file.basename}) can not be read as #{type} key")
        end
      end
    end.call.tap do |key|
      raise OpenSSL::PKey::PKeyError, 'Not a PRIV key' unless key&.private?

      raise OpenSSL::PKey::PKeyError, 'Neither PUB key nor PRIV key' unless key
    end
  end

  # Convert PEM file
  #
  # @return [Array<Pathname>]
  def pem_convert(to: BOOT_FILES.fetch(:key))
    [BOOT_FILES.fetch(:pem), to].tap do |files|
      if files[0].file?
        pem_detect(files[0])

        sh(*%w(dropbearconvert openssh dropbear).concat(files.map(&:to_s)))
      end
    end
  end

  # Generate server key.
  #
  # @return [Pathname]
  def gen_key
    BOOT_FILES.fetch(:key).tap do |key|
      pem_convert(to: key)

      sh('dropbearkey', '-f', key.to_s, '-t', 'rsa') unless key.file?
    end
  end

  # Create required directories
  #
  # @return [self]
  def make_directories
    self.tap do
      Boot::ThreadPool.new do |pool|
        boot_directories.clone.push(confdir).map do |fp|
          pool.schedule { fs.mkdir_p(fp.to_s) unless fp.exist? }
        end
      end
    end
  end
end

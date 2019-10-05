# frozen_string_literal: true

require_relative '../services'

# Install services.
#
# Servive startup scripts are located in ``/etc/service``
# according to ``svctl`` config file: ``/etc/sv-utils.yml``.
# They are copied to ``SVDIR`` environment variable path.
#
# Each service MUST have a ``manifest.yml`` file.
#
# Sample:
#
# ```yaml
# ---
# enabled: true
# auto_start: true
# ```
class Boot::Services::Setup
  autoload(:YAML, 'yaml')
  autoload(:ERB, 'erb')
  autoload(:Pathname, 'pathname')
  autoload(:FileUtils, 'fileutils')
  include(FileUtils::Verbose)

  # @param [String|nil] path for service(s) location
  def initialize(path = nil)
    @path = Pathname.new(path || fetch_path)
    @svdir = Pathname.new(ENV.fetch('SVDIR'))
  end

  def call
    rm_rf(svdir)
    mkdir_p(svdir, mode: 0o755)
    [:dump_services, :load_services].map do |m|
      Thread.new { __send__(m) }
    end.map(&:join)
  end

  # Get a simple hash as service name => auto_start (boolean).
  #
  # @return [Hash{Symbol => Boolean}]
  def config
    # @formatter:off
    manifests
      .keep_if { |_fp, config| config['enabled'] }
      .map { |fp, config| [fp.dirname.basename.to_s.to_sym, config] }
      .map { |name, config| [name, config['auto_start']] }
      .to_h
    # @formatter:on
  end

  # List manifest files and get config indexed by filepaths.
  #
  # @return [Hash{Pathname => Hash}]
  def manifests
    # @formatter:off
    Dir.glob(path.join('*/manifest.yml'))
       .sort
       .map { |fp| Pathname.new(fp) }
       .keep_if { |fp| fp.file? and fp.readable? }
       .map { |fp| [fp, YAML.safe_load(ERB.new(fp.read).result)] }
       .map { |fp, config| [fp, defaults_apply(config)] }
       .to_h
    # @formatter:on
  end

  protected

  # Path to (original) services.
  #
  # @return [Pathname]
  attr_reader :path

  # @return [Pathname]
  attr_reader :svdir

  # @param [Hash] config
  #
  # @return [Hash]
  def defaults_apply(config)
    # @formatter:off
    config.tap do
      {
        'enabled' => false,
        'auto_start' => false,
      }.tap do |defaults|
        defaults.each { |k, v| config[k] = v unless config.key?(k) }
      end
    end
    # @formatter:on
  end

  # Get commands as args passed to svctl
  #
  # @return [Array]
  def commands
    config.to_h.map do |name, auto|
      # @formatter:off
      ['enable',
       name.to_s, '--%<no>sauto-start' % {
         no: auto ? '' : 'no-'
       }]
      # @formatter:on
    end
  end

  def dump_services
    Pathname.new(path).join('config.yml').tap do |fp|
      YAML.dump(config.transform_keys(&:to_s)).tap { |c| fp.write(c) }
      chmod(0o444, fp.to_s)
    end
  end

  def load_services
    require 'sv/utils/cli'

    commands.map do |args|
      Thread.new { Sv::Utils::CLI.call(:control, args) }
    end.map(&:join)
  end

  # Extract path from configuration.
  #
  # @return [String]
  def fetch_path
    require 'sv/utils/config'

    Sv::Utils::Config.new.tap do |config|
      return config['control']['paths'].fetch(0)
    end
  end
end

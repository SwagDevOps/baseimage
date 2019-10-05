# frozen_string_literal: true

require_relative '../boot'

# Configurable autoload.
class Boot::Autoload
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  # @return [Pathname]
  attr_reader :path

  # @param [String] path
  def initialize(path)
    @path = Pathname.new(path)
  end

  # Path where files are stored.
  #
  # @return [Pathname]
  def dir
    path.join('autoload')
  end

  # Autoload configuration files.
  #
  # @return [Arrtay<Pathname>]
  def files
    Dir.glob(dir.join('*.yml')).sort.map { |fp| Pathname.new(fp) }
  end

  # Registrables.
  #
  # @return [Hash{Symbol => Pathname}]
  def registrables
    {}.tap do |h|
      files.map do |file|
        YAML.safe_load(file.read, [Symbol]).tap do |c|
          c.map { |k, fp| [k, path.join(fp)] }.each do |k, v|
            h[k.to_sym] = v.to_path
          end
        end
      end
    end
  end

  # @return [Hash{Symbol => Pathname}]
  def register_on(target)
    registrables.tap do |h|
      h.each { |k, v| target.__send__(:autoload, k, v) }
    end
  end

  alias call register_on

  class << self
    # @param [Class] target
    # @param [String] path
    #
    # @return [Hash{Symbol => Pathname}]
    def register(target, path)
      self.new(path).call(target)
    end
  end
end

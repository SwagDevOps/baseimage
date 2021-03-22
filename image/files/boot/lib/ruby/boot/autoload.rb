# frozen_string_literal: true

require_relative '../boot'

# Autoload.
class Boot::Autoload
  autoload(:Pathname, 'pathname')
  autoload(:YAML, 'yaml')

  # Registrables.
  #
  # @return [Hash{Symbol => Pathname}]
  def registrables
    {}.tap do |h|
      Pathname.new(__FILE__.gsub(/\.rb$/, '.yml')).realpath.yield_self do |file|
        YAML.safe_load(file.read, [Symbol]).tap do |c|
          c.transform_values { |fp| Pathname.new(__dir__).join(fp) }.each do |k, v|
            h[k.to_sym] = v
          end
        end
      end
    end
  end

  # @return [Hash{Symbol => Pathname}]
  def register_on(target)
    registrables.tap do |h|
      h.each { |k, v| target.__send__(:autoload, k, v.to_s) }
    end
  end

  alias call register_on
end

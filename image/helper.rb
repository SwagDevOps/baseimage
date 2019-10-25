# frozen_string_literal: true

autoload(:YAML, 'yaml')
autoload(:Shellwords, 'shellwords')
autoload(:Pathname, 'pathname')

self.singleton_class.__send__(:define_method, :quote) do |input|
  input.to_s.inspect
end

self.singleton_class.__send__(:define_method, :packages) do
  Pathname.new(__dir__).join('packages.yml').read.tap do |c|
    return YAML.safe_load(c).fetch('apk').sort
  end
end

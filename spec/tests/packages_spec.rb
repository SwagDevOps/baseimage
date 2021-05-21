# frozen_string_literal: true

autoload(:Pathname, 'pathname')
autoload(:YAML, 'yaml')

# @note This spec was using ``command("/sbin/apk info -e #{package}")``
#        with ``its(:stdout) { should match(/^#{package}$/) }``
#        ATM it use ``be_installed`` matcher
describe(*spec.to_a) do
  Pathname.new(__FILE__.gsub(/\.rb$/, '.yml')).read.tap do |c|
    YAML.safe_load(c).each do |installer, packages|
      packages.each do |package|
        describe package(package) do
          it { should be_installed.by(installer) }
        end
      end
    end
  end
end

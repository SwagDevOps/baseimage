# frozen_string_literal: true

autoload :Vendorer, 'vendorer'
autoload :CLOBBER, 'rake/clean'

task default: [:build]

task 'pre_build' do
  Vendorer.new(update: false).tap do |v|
    config_locations = ['Vendorfile.rb', 'Vendorfile']
    config_location = config_locations.detect { |f| File.exist?(f) }

    v.parse(File.read(config_location || config.locations.last))
  end
end

CLOBBER.push('image/files/build/vendor')

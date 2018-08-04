# frozen_string_literal: true

autoload :Vendorer, 'vendorer'
autoload :CLOBBER, 'rake/clean'
autoload :Tenjin, 'tenjin'

task default: [:build]

task "#{image.path}/Dockerfile" do |task|
  image.version.to_h.merge(image: image).tap do |context|
    Tenjin::Engine
      .new(cache: false)
      .render("#{task.name}.tpl", context)
      .tap { |output| Pathname.new(task.name).write(output) }
  end
end

task "#{image.path}/files/build/vendor" do |task|
  Dir.chdir(image.path) do
    Vendorer.new(update: false).tap do |v|
      config_locations = ['Vendorfile.rb', 'Vendorfile']
      config_location = config_locations.detect { |f| File.exist?(f) }

      v.parse(File.read(config_location || config_locations.last))
    end
  end
end

["#{image.path}/Dockerfile",
 "#{image.path}/files/build/vendor"].each do |name|
  CLOBBER.push(name)

  task 'pre_build' do
    Rake::Task[name].invoke
  end
end

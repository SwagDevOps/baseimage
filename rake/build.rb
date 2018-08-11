# frozen_string_literal: true

autoload :Vendorer, 'vendorer'
autoload :CLOBBER, 'rake/clean'
autoload :Tenjin, 'tenjin'

task default: [:build]

image.tap do |c|
  image.singleton_class.__send__(:define_method, :vendor) do
    Pathname.new("#{c.path}/build/vendor")
  end

  image.singleton_class.__send__(:define_method, :dockerfile) do
    Pathname.new("#{c.path}/Dockerfile")
  end
end

task image.dockerfile do |task|
  image.version.to_h.merge(image: image).tap do |context|
    Tenjin::Engine
      .new(cache: false)
      .render("#{task.name}.tpl", context)
      .tap { |output| Pathname.new(task.name).write(output) }
  end
end

task image.vendor do |task, args|
  ['Vendorfile.rb', 'Vendorfile'].map { |f| image.path.join(f) }.tap do |files|
    Vendorer.new(update: args.to_a.include?('update')).tap do |v|
      self.image.vendor.tap do |dir|
        v.singleton_class.__send__(:define_method, :vendor) { dir }
      end

      (files.detect(&:file?) || files.last).tap { |f| v.parse(f.read) }
    end
  end
end

[image.dockerfile, image.vendor].each do |name|
  CLOBBER.push(name.to_s)

  task 'pre_build' do
    Rake::Task[name].invoke
  end
end

desc 'Build image (with update)'
task 'build:update' do
  Rake::Task[image.vendor].invoke('update')
  Rake::Task[:build].invoke
end

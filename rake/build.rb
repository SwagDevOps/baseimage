# frozen_string_literal: true

# noinspection RubyBlockToMethodReference
{
  Vendorer: 'vendorer',
  CLOBBER: 'rake/clean',
  Tenjin: 'tenjin',
}.each { |k, v| autoload(k, v) }

task default: [:build]

task image.dockerfile do |task|
  image.version.to_h.merge(image: image).tap do |context|
    Tenjin::Engine
      .new(cache: false)
      .render("#{task.name}.tpl", context)
      .tap { |output| Pathname.new(task.name).write(output) }
  end
end

task image.vendor do |_task, args|
  # noinspection RubyLiteralArrayInspection
  ['Vendorfile.rb', 'Vendorfile', 'vendorer.yml'].map { |f| image.path.join(f) }.tap do |files|
    Vendorer.new(update: args.to_a.include?('update')).tap do |v|
      v.singleton_class.tap do |vendorer_class|
        self.image.tap do |image|
          vendorer_class.__send__(:define_method, :image) { image }
        end

        self.image.vendor.tap do |dir|
          vendorer_class.__send__(:define_method, :vendor) { dir }
        end
      end

      (files.detect(&:file?) || files.last).tap do |f|
        (f.to_s =~ /\.yml$/ ? Pathname.new(__dir__).join('resources', 'vendorer.rb') : f).tap do |file|
          v.parse(file.read)
        end
      end
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

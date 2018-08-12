# frozen_string_literal: true

require_relative '../build'

# Provide install method, to install gem from a given directory.
module Build::Gem
  autoload :Pathname, 'pathname'
  autoload :Shellwords, 'shellwords'

  include Build::Shell

  singleton_class.include(self)

  def install(dir, bin_dir = '/usr/local/bin')
    build(dir).tap do |gem|
      ['--no-user-install', '--no-post-install-message', '--no-suggestions',
       '--no-document', '--clear-sources',
       '--no-wrappers', '--env-shebang', '--format-executable',
       '--conservative', '--minimal-deps'].sort.tap do |options|
        ['install', gem, '--bindir', bin_dir]
          .push(*options)
          .tap { |cmd| gem_cmd(*cmd) }
      end
    end
  end

  def build(dir)
    gem_name = Pathname.new(dir).basename
    Dir.chdir(dir) do
      gem_cmd('build', "#{gem_name}.gemspec")

      Dir.glob("#{gem_name}-*.gem").map { |fp| Pathname.new(fp) }
         .fetch(0).realpath
    end
  end

  protected

  def gem_cmd(*cmd)
    ['gem'].push(*(cmd + ['--norc'])).tap { |command| sh(*command) }
  end
end

# frozen_string_literal: true

require_relative '../build'

# Provide install method, to install gem from a given directory.
module Build::Gem
  autoload :Pathname, 'pathname'
  autoload :Shellwords, 'shellwords'
  autoload :Fileutils, 'fileutils'

  include Build::Shell

  singleton_class.include(self)

  def install(gem, options = {})
    options = { bin_dir: '/usr/local/bin', version: '>= 0' }.merge(options)

    ['install', options[:local] ? build(gem) : gem,
     '--bindir', options.fetch(:bin_dir),
     '--version', options.fetch(:version)]
      .push(*install_defaults)
      .tap { |cmd| gem_cmd(*cmd) }
  end

  # Build gem from given directory.
  #
  # @return [Pathname] built gem
  def build(dir)
    gem_name = Pathname.new(dir).basename
    Dir.chdir(dir) do
      "#{gem_name}-*.gem".tap do |pattern|
        Dir.glob(pattern).each { |fp| Fileutils.rm_f(fp) }

        gem_cmd('build', "#{gem_name}.gemspec")

        return Dir.glob(pattern)
                  .map { |fp| Pathname.new(fp) }.fetch(0).realpath
      end
    end
  end

  protected

  # Execute given command.
  def gem_cmd(*cmd)
    ['gem'].push(*(cmd + ['--norc'])).tap { |command| sh(*command) }
  end

  # Get defaults for install.
  #
  # @return [Array<String>]
  def install_defaults
    ['--no-user-install', '--no-post-install-message', '--no-suggestions',
     '--no-document', '--clear-sources',
     '--no-wrappers', '--env-shebang', '--format-executable',
     '--conservative', '--minimal-deps'].sort
  end
end

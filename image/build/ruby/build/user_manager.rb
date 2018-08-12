# frozen_string_literal: true

require_relative '../build'

# Provide users/groups related methods.
class Build::UserManager
  autoload :Etc, 'etc'
  autoload :Open3, 'open3'
  autoload :FileUtils, 'fileutils'

  include Build::Shell

  def initialize(futils = FileUtils::Verbose)
    @futils = futils
  end

  def group?(group)
    !!Etc.getgrnam(group)
  rescue ArgumentError
    false
  end

  def create_system_group(name)
    create_system_group!(name) unless group?(name)
  end

  def create_system_group!(name)
    sh('addgroup', '-S', name)
  end

  # Create a system user
  #
  # create_system_user "${name}" "${home}"
  def create_system_user(name, home_dir)
    create_system_group(name)
    sh('adduser', '-HS', name,
       '-h', home_dir,
       '-G', name, '-g', name,
       '-s', Open3.capture2e('which', 'nologin')[0].rstrip)
  end

  # Apply permissions
  #
  # apply_perms "${path}" "${owner}" "${mode}"
  def apply_perms(paths, owner, mode = nil)
    paths.tap do |paths| # rubocop:disable Lint/ShadowingOuterLocalVariable
      user, group = owner.to_s.split(':')

      futils.chown(user, group, paths)
      futils.chmod(mode, paths) if mode
    end
  end

  def change_shell(user, shell)
    shell = Open3.capture2e('which', shell.to_s)[0].rstrip
    if shell.empty?
      raise ArgumentError, "shell: #{shell.to_s.inspect} not found"
    end

    sh('usermod', '--shell', shell, user)
  end

  protected

  # @return [FileUtils]
  attr_reader :futils
end

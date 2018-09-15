# frozen_string_literal: true

# @note This spec does not use the ``be_installed`` matcher
#       because it seems too permissive (lacks of efficiency).
describe 'installed packages', :packages do
  [
    %w[bash bash-completion htop multitail screen],
    %w[runit dumb-init busybox file tzdata],
    %w[curl sed tar grep shadow pwgen rsync],
    %w[vim less coreutils sed procps],
    %w[dropbear dropbear-convert dropbear-scp],
    %w[ruby ruby-bundler],
    %w[ruby-bigdecimal ruby-etc ruby-fiddle ruby-json],
  ].flatten.each do |package|
    describe command("/sbin/apk info -e #{package}") do
      its(:stdout) { should match(/^#{package}$/) }
    end
  end
end

# frozen_string_literal: true

describe 'services', :services do
  describe command('ps -Ao args --no-headers') do
    ['/usr/sbin/crond -S -f',
     '/sbin/syslogd -n -D',
     '/usr/sbin/dropbear -Fsp 22 -r /etc/dropbear/host_rsa'].each do |cmd|
      its(:stdout) { should match(/^#{cmd}$/) }
    end
  end
end

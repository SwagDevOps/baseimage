# frozen_string_literal: true

describe 'services', :services do
  {
    cron: '/usr/sbin/crond -S -f',
    syslog: '/sbin/syslogd -n -D',
    ssh: '/usr/sbin/dropbear -Fsp 22 -r /etc/dropbear/host_rsa'
  }.each do |service, command|
    describe command('ps -Ao args --no-headers') do
      its(:stdout) { should match(/^#{command}$/) }
    end

    describe command("bash -lc '/sbin/sv status #{service}'") do
      its(:stdout) { should match(/^run:\s+#{service}:/) }
    end
  end
end

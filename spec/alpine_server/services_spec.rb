# frozen_string_literal: true

describe 'services', :services do
  {
    cron: '/usr/sbin/crond -S -f',
    syslog: '/sbin/syslogd -Dnb10 -s200 -O /proc/1/fd/2',
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

describe 'services', :services do
  # This services SHOULD be provided by BusyBox
  ['/sbin/syslogd',
   '/usr/sbin/crond'].each do |binary|
    describe command("#{binary} --help 2>&1") do
      its(:stdout) { should match(/^BusyBox v[0-9]+.[0-9 \.]+/) }
    end
  end
end

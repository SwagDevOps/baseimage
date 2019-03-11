# frozen_string_literal: true

describe 'login shell environment', :environment do
  describe command('bash -lc /usr/bin/env') do
    let(:path) do
      '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
    end

    its(:stdout) { should match(/^PATH=#{path}$/) }
    its(:stdout) { should match(/^SVDIR=/) }
    its(:stdout) { should match(/^SVWAIT=/) }
    its(:stdout) { should match(%r{^TZ=UTC$}) }
  end
end

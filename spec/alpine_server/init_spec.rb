# frozen_string_literal: true

describe 'init', :init do
  let(:version) { '1.2.2' }
  let(:md5) { '5cc73adacb140d682c73082ba1329960' } # x86_64

  describe file('/sbin/init') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }

    if 'x86_64' == RbConfig::CONFIG['host_cpu']
      its(:md5sum) { should eq(md5) }
    end
  end

  describe command('/sbin/init --version 2>&1') do
    its(:stdout) { should match(/^dumb-init v#{version}$/) }
  end
end

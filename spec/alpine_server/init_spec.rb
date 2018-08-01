# frozen_string_literal: true

describe 'init', :init do
  describe file('/sbin/init') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 775 }

    its(:md5sum) { should eq('7dba581e723e379c588d67a6b2b83b2a') }
  end

  describe command('/sbin/init --version 2>&1') do
    its(:stdout) { should match(/^dumb-init v1.2.1$/) }
  end
end

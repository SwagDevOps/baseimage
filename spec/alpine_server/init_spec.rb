# frozen_string_literal: true

describe 'init', :init do
  let(:version) { '1.2.2' }
  let(:md5) { '79f195aae73dda5424c9578918ca2623' }

  describe file('/sbin/init') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 775 }

    its(:md5sum) { should eq(md5) }
  end

  describe command('/sbin/init --version 2>&1') do
    its(:stdout) { should match(/^dumb-init v#{version}$/) }
  end
end

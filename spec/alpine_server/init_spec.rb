# frozen_string_literal: true

describe 'init', :init do
  describe file('/sbin/init') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
  end

  describe command('/sbin/init --version 2>&1') do
    its(:stdout) { should match(/^dumb-init v[0-9]+(\.[0-9]){2}$/) }
  end
end

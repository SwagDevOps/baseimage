# frozen_string_literal: true

describe 'executables files', :exe, :executables do
  describe file('/usr/bin/vim') do
    it { should be_file }
    it { should be_symlink }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 777 }
  end

  describe command('/usr/bin/vim --version') do
    its(:stdout) { should match(/^NVIM v[0-9]+\.[0-9]+\.[0-9]+/i) }
    its(:exit_status) { should eq 0 }
  end
end

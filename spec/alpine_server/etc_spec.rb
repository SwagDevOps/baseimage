# frozen_string_literal: true

describe 'etc contents', :etc do
  describe file('/etc/alpine-release') do
    it { should be_file }
    its(:content) { should match(/^3.8.[0-9]+$/) }
  end

  describe file('/etc/profile.d/environment.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode 644 }
  end

  describe file('/etc/environment') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode 644 }
  end
end

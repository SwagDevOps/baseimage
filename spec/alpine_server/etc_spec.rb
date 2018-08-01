# frozen_string_literal: true

describe 'etc contents', :etc do
  describe file('/etc/alpine-release') do
    it { should be_file }
    its(:content) { should match(/^3.8.[0-9]+$/) }
  end

  ['/etc/profile.d/environment.sh',
   '/etc/environment'].each do |fp|
    describe file(fp) do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
    end
  end
end

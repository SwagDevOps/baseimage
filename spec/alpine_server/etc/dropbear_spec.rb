# frozen_string_literal: true

describe 'etc/dropbear files', :etc, :'etc/dropbear' do
  describe file('/etc/dropbear/host_rsa') do
    it { should be_file }

    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 400 }
  end
end

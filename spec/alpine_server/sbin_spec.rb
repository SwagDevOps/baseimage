# frozen_string_literal: true

autoload(:Pathname, 'pathname')

describe 'sbin files', :sbin do
  describe file('/sbin/runsvdir-start') do
    it { should be_file }

    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }

    its(:md5sum) { should eq '07fc5baddc59fb078bf4c9978c4741d7' }
  end
end

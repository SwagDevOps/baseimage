# frozen_string_literal: true

describe 'log files', :log do
  describe file('/var/log/messages') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'syslog' }
    it { should be_mode 644 }
  end

  describe file('/var/log/secure') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 640 }
  end

  describe file('/var/log/ylem') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 640 }
  end

  describe file('/var/log/lastlog') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'utmp' }
    it { should be_mode 644 }
  end
end

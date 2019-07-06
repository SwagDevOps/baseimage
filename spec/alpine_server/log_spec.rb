# frozen_string_literal: true

describe 'log files', :log do
  describe file('/var/log/lastlog') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'utmp' }
    it { should be_mode 644 }
  end
end

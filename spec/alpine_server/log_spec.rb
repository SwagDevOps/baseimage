# frozen_string_literal: true

describe 'log files', :log do
  ['/var/log/lastlog',
   '/var/log/messages',
   '/var/log/ylem'].each do |fp|
    describe file(fp) do
      it { should be_file }
      it { should be_owned_by 'root' }
    end
  end
end

# frozen_string_literal: true

describe(*spec.to_a) do
  describe file('/var/cache') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
    it { should be_empty }
  end
end


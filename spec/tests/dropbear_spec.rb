# frozen_string_literal: true

describe(*spec.to_a) do
  {
    dropbear: '/usr/sbin/dropbear',
    # This executables are executed during dropbear setup (init)
    dropbearconvert: '/usr/bin/dropbearconvert',
    dropbearkey: '/usr/bin/dropbearkey',
  }.each do |k, file|
    describe file(file) do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 755 }
    end

    describe command("/usr/bin/which #{k}") do
      its(:stdout) { should match(/^#{file}$/) }
    end
  end
end

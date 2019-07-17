# frozen_string_literal: true

autoload(:Pathname, 'pathname')

describe 'home files', :home do
  describe file('/root/.ssh') do
    it { should be_directory }

    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
  end

  describe file('/root/.ssh/authorized_keys') do
    it { should be_file }

    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 400 }
  end
end

describe 'home files', :home do
  # Check files installed during image build (see Dockerfile)
  #
  # @formatter:off
  # noinspection RubyLiteralArrayInspection
  [
    '.bash_logout',
    '.bash_logout',
    '.gemrc',
    '.muttrc',
    '.profile',
    '.screenrc',
    '.vimrc',
  ].map { |fp| Pathname.new('/root').join(fp).to_s }.each do |fp|
    describe file(fp) do
      it { should be_file }

      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
    end
  end
  # @formatter:on
end

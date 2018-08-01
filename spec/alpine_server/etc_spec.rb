# frozen_string_literal: true

describe 'etc contents', :etc do
  describe file('/etc/alpine-release') do
    it { should be_file }
    its(:content) { should match(/^3.8.[0-9]+$/) }
  end
end

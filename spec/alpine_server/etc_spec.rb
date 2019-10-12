# frozen_string_literal: true

describe 'etc contents', :etc do
  describe file('/etc/alpine-release') do
    it { should be_file }

    its(:content) { should match(/^[0-9]+.[0-9]+.[0-9]+$/) }
    its(:content) { should eq("#{ALPINE_VERSION}\n") }
  end

  # noinspection RubyLiteralArrayInspection
  # @formatter:off
  [
    '/etc/profile.d/environment.sh',
    '/etc/environment',
    '/etc/issue',
    '/etc/issue.net',
    '/etc/image.yml'
  ].each do |fp|
    describe file(fp) do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 444 }
    end
  end
  # @formatter:on
end

describe '/etc/issue* files', :etc do
  describe file('/etc/issue') do
    its(:content) do
      should eq("Alpine Linux #{ALPINE_VERSION} \\n \\l\n\n")
    end
  end

  describe file('/etc/issue.net') do
    its(:content) do
      should eq("Alpine #{ALPINE_VERSION}\n")
    end
  end

  describe file('/etc/image.yml') do
    # noinspection RubyLiteralArrayInspection
    ['major', 'minor', 'patch', 'maintainer', 'email', 'homepage'].each do |k|
      its(:content_as_yaml) { should include(k => IMAGE_VERSION[k]) }
    end
  end
end

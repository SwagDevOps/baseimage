# frozen_string_literal: true

# bundle install --path vendor/bundle

source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'kamaze-docker_image', \
      github: 'SwagDevOps/kamaze-docker_image', branch: 'master'

  gem 'kamaze-version', '~> 1.0'
  gem 'rake', '~> 12.3'
  gem 'tenjin', '~> 0.7'
  gem 'vendorer', '~> 0.1'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'rubocop', '~> 0.56'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
end

group :test do
  gem 'rspec', '~> 3.7'
  gem 'serverspec', '~> 2.41'
end

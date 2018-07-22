# frozen_string_literal: true

# bundle install --path vendor/bundle

source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'kamaze-docker_image', \
      github: 'SwagDevOps/kamaze-docker_image', branch: 'master'

  gem 'rake', '~> 12.3'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  gem 'vendorer', '~> 0.1'
end

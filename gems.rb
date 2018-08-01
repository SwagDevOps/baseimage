# frozen_string_literal: true

# bundle install --path vendor/bundle

source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  gem 'kamaze-docker_image', \
      github: 'SwagDevOps/kamaze-docker_image', branch: 'master'

  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'rake', '~> 12.3'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  gem 'vendorer', '~> 0.1'
end

group :development do
  gem 'rubocop', '~> 0.56'
end

group :test do
  gem 'fuubar', '~> 2.3'
  gem 'rspec', '~> 3.7'
  gem 'serverspec', '~> 2.41'
end

source 'https://rubygems.org'
ruby '1.9.3', engine: 'rbx', engine_version: '2.0.0rc1'

gem 'sinatra', '~> 1.4.0'
gem 'puma', '~> 2.0.0.b6'

gem 'activesupport', '~> 3.2.11'
gem 'data_mapper', '~> 1.2.0'
gem 'aws-sdk', '~> 1.8.1'
gem 'json', '~> 1.7.6'
gem 'haml', '~> 4.0.0'
gem 'maruku', '~> 0.6.1'

group :production do
  gem 'dm-postgres-adapter', '~> 1.2.0'
  gem 'newrelic_rpm', '~> 3.5.6'
  gem 'gabba', '~> 1.0.1'
end

group :development do
  gem 'foreman', '~> 0.61'
  gem 'dm-sqlite-adapter', '~> 1.2.0'
end

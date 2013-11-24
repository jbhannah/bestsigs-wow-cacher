source 'https://rubygems.org'
ruby '2.1.0', engine: 'rbx', engine_version: '2.2.1'

gem 'sinatra', '~> 1.4.2'
gem 'puma', '~> 2.0.1'
gem 'rake', '~> 10.0.4'

gem 'activesupport', '~> 3.2.13'
gem 'data_mapper', '~> 1.2.0'
gem 'aws-sdk', '~> 1.11.0'
gem 'json', '~> 1.8.0'
gem 'haml', '~> 4.0.3'
gem 'kramdown', '~> 1.2.0'

gem 'rubysl', '~> 2.0', platform: :rbx
gem 'racc', '~> 1.4.10'

group :production do
  gem 'dm-postgres-adapter', '~> 1.2.0'
  gem 'newrelic_rpm'
  gem 'gabba', '~> 1.0.1'
end

group :development do
  gem 'foreman', '~> 0.63'
  gem 'dm-sqlite-adapter', '~> 1.2.0'
end

source 'https://rubygems.org'
ruby '2.1.0', engine: 'rbx', engine_version: '2.2.1'

gem 'sinatra', '~> 1.4.2'
gem 'puma', '~> 2.7.1'
gem 'rake', '~> 10.1.1'

gem 'activesupport', '~> 4.0.2'
gem 'data_mapper', '~> 1.2.0'
gem 'aws-sdk', '~> 1.31.3'
gem 'json', '~> 1.8.0'
gem 'haml', '~> 4.0.3'
gem 'kramdown', '~> 1.3.0'

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

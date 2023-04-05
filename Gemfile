source 'http://rubygems.org'

gem 'rake', '>= 12.3.3'
gem 'rails', '6.1.7.3'
gem 'whenever', :require => false
gem 'passenger', '>= 5.3.2'
gem 'dalli', '>= 3.2.3'
gem 'rb-readline'

# simulate a web browser
gem 'mechanize', '>= 2.8.5'

# memory logger
gem 'oink'
gem 'xml-simple'
gem 'koala', '~> 1.5.0'

gem 'haml', '>= 5.0.0'

gem 'rails3-jquery-autocomplete', '~> 1.0.12'

gem 'icalendar'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '>= 5.0.8'
  gem 'coffee-rails', '>= 4.2.2'
  gem 'uglifier', '>= 2.7.2'
end

gem 'jquery-rails', '>= 4.4.0'

gem 'rack', '>= 3.0.0'
gem 'rack-ssl', '>= 1.3.4', :require => 'rack/ssl'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :production do
  #gem 'pg'
  gem 'mysql2'
end

group :development do
  gem 'guard'
  gem 'guard-livereload', '>= 2.5.2'
  gem 'sqlite3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

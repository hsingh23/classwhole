source 'http://rubygems.org'

gem 'rake'
gem 'rails', '7.0.8.1'
gem 'whenever', :require => false
gem 'passenger', '>= 3.0.21'
gem 'dalli'
gem 'rb-readline'

# simulate a web browser
gem 'mechanize', '>= 2.6.0'

# memory logger
gem 'oink'
gem 'xml-simple'
gem 'koala', '~> 1.5.0'

gem 'haml'

gem 'rails3-jquery-autocomplete', '~> 1.0.12'

gem 'icalendar'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '>= 5.0.8'
  gem 'coffee-rails', '>= 4.2.2'
  gem 'uglifier'
end

gem 'jquery-rails', '>= 4.0.1'

gem 'rack', '>= 2.2.8.1'
gem 'rack-ssl', '>= 1.3.3', :require => 'rack/ssl'

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
  gem 'guard-livereload'
  gem 'sqlite3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

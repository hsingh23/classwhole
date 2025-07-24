source 'http://rubygems.org'

gem 'rake'
gem 'rails', '3.2.4'
gem 'whenever', :require => false
gem 'passenger'
gem 'dalli'
gem 'rb-readline'

# simulate a web browser
gem 'mechanize', '>= 2.6.0'

# memory logger
gem 'oink'
gem 'xml-simple'
gem 'koala', "~> 1.2.0beta"

gem 'haml'

gem 'rails3-jquery-autocomplete', '~> 1.0.0'

gem 'icalendar'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '>= 3.2.0'
  gem 'coffee-rails', '>= 3.2.0'
  gem 'uglifier'
end

gem 'jquery-rails', '>= 2.2.1'

gem 'rack'
gem 'rack-ssl', :require => 'rack/ssl'

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
  gem 'guard', '>= 1.6.2'
  gem 'guard-livereload', '>= 1.2.0'
  gem 'sqlite3'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

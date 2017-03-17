source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# if version doesn't work, use rvm to switch your ruby version
ruby '2.3.3'
gem 'bcrypt',                 '~> 3.1.7'
gem 'bootstrap-sass'
gem 'twitter-typeahead-rails'
gem 'sass-rails',             '~> 5.0'
gem 'rails',                  '~> 5.0.1'
gem 'puma',                   '~> 3.0'
gem 'uglifier',               '>= 1.3.0'
gem 'coffee-rails',           '~> 4.2'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks',             '~> 5'
gem 'jbuilder',               '~> 2.5'
gem 'coffee-script-source',   '1.8.0'
gem 'wdm',                    '>= 0.1.0' if Gem.win_platform?
gem 'default_value_for',      '~> 3.0', '>= 3.0.2'
gem 'bourbon',                '4.3.2'
gem 'cocoon'
gem 'selectize-rails'
gem 'kaminari'
gem 'tinymce-rails',          '~> 4.3'
gem 'device_detector'
gem 'pry'

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug',      '9.0.0', platform: :mri
end


group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console',           '>= 3.3.0'
  gem 'listen',                '~> 3.0.5'
  # Change application code and see the changes without restarting the server
  gem 'spring',                '1.7.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Run 'bundle exec guard' in a terminal to run your tests automatically
  gem 'guard-rspec', require: false
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.5'
  gem 'rspec-mocks', '~> 3.4', '>= 3.4.1'
  gem 'capybara'
  gem 'selenium-webdriver', '3.3.0'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

group :production do
  # Use postrgres in production
  # Use postrgres in production
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

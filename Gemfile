source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.4'
# Use mysql as the database for Active Record
gem 'mysql2', '0.4.10'
# Use Puma as the app server
gem 'puma', '3.11.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '1.0.2'
# For secrets
gem 'figaro', '1.1.1'
# for encrypted passwords
gem 'bcrypt', '3.1.11'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.1.0', platforms: [:mri, :mingw, :x64_mingw]
  # rspec testing
  gem 'rspec-rails', '3.7.2'
  gem 'shoulda-matchers', '3.1.2', require: false
  # for data factories
  gem 'factory_bot_rails', '4.8.2'
end

group :development do
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  # faster testing
  gem 'spring-commands-rspec', '1.0.4'
  # for viewing emails in browser in development mode
  gem 'letter_opener', '1.4.1'
  # for deployments
  gem 'capistrano', '3.9.0'
  gem 'capistrano-rails', '1.3.0'
  gem 'capistrano-rbenv', '2.1.1'
  gem 'capistrano-rails-console', '1.0.2'
  gem 'airbrussh', '1.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '1.2017.3', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.7'
gem 'puma', '~> 3.12'

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec' #bundle exec spring rspec
  gem 'mysql2', '>= 0.3.18', '< 0.5'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem "pry-rails"
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :production do 
  gem 'pg'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'bcrypt', '~> 3.1.12'
gem 'devise'
gem 'active_model_serializers', '~> 0.10.0'
gem 'ransack'
gem 'omniauth'
gem 'devise_token_auth' #rails g devise_token_auth:install User auth
gem 'rack-cors'
gem 'rails-i18n', '~> 5.0.0'
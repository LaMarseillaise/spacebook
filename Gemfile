source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.1'
gem 'pg'
gem 'thin'

gem 'sass-rails', '~> 4.0.3'
gem 'less-rails'
gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'will_paginate-bootstrap'
gem 'simple_form'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'devise'
gem 'figaro'
gem 'paperclip', git: 'git://github.com/thoughtbot/paperclip.git'
gem 'aws-sdk'
gem 'bcrypt', '~> 3.1.7'
gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  gem 'spring'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'faker'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'capybara'
end

group :test do
  gem 'shoulda-matchers', require: false
end

group :production do
  gem 'rails_12factor'
end

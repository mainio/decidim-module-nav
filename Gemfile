# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

# Inside the development app, the relative require has to be one level up, as
# the Gemfile is copied to the development_app folder (almost) as is.
base_path = ""
base_path = "../" if File.basename(__dir__) == "development_app"
require_relative "#{base_path}lib/decidim/nav/version"

DECIDIM_VERSION = Decidim::Nav.decidim_version

gem "decidim", DECIDIM_VERSION
gem "decidim-nav", path: "."

gem "bootsnap", "~> 1.4"

# This is a temporary fix for: https://github.com/rails/rails/issues/54263
# Without this downgrade Activesupport will give error for missing Logger
gem "concurrent-ruby", "1.3.4"

gem "puma", ">= 6.4.2"

gem "faker", "~> 3.2.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION

  gem "brakeman", "~> 5.2"
  gem "parallel_tests", "~> 4.2"

  # rubocop & rubocop-rspec are set to the following versions because of a change where FactoryBot/CreateList
  # must be a boolean instead of contextual. These version locks can be removed when this problem is handled
  # through decidim-dev.
  gem "rubocop", "~>1.28"
  gem "rubocop-faker"
  gem "rubocop-rspec", "2.20"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.8"
  gem "spring", "~> 4.1.3"
  gem "spring-watcher-listen", "~> 2.1"
  gem "web-console", "~> 4.2"
end

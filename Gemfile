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

gem "puma", ">= 5.6.2"

gem "faker", "~> 2.14"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION

  gem "brakeman", "~> 5.2"
  gem "parallel_tests", "~> 3.7"
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end

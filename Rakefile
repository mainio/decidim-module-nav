# frozen_string_literal: true

require "decidim/dev/common_rake"

def install_module(path)
  Dir.chdir(path) do
    system("bundle exec rake decidim_nav:install:migrations")
    system("bundle exec rake db:migrate")
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task :test_app do
  ENV["RAILS_ENV"] = "test"
  generate_decidim_app(
    "spec/decidim_dummy_app",
    "--app_name",
    "#{base_app_name}_test_app",
    "--path",
    "../..",
    "--recreate_db",
    "--skip_gemfile",
    "--demo"
  )
  install_module("spec/decidim_dummy_app")
end

desc "Generates a development app"
task :development_app do
  generate_decidim_app(
    "development_app",
    "--app_name",
    "#{base_app_name}_development_app",
    "--path",
    "..",
    "--recreate_db",
    "--demo"
  )
  install_module("development_app")
  seed_db("development_app")
end

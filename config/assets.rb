# frozen_string_literal: true

# Base path of the module
base_path = File.expand_path("..", __dir__)

# Register an additional load path for webpack
Decidim::Webpacker.register_path("#{base_path}/app/packs")

# Entrypoints for the module
Decidim::Webpacker.register_entrypoints(
  decidim_nav_admin: "#{base_path}/app/packs/entrypoints/decidim_nav_admin.js",
  decidim_nav_header: "#{base_path}/app/packs/entrypoints/decidim_nav_header.js"
)

# Stylesheets for the module
Decidim::Webpacker.register_stylesheet_import("stylesheets/nav")

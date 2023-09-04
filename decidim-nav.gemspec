# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/nav/version"

Gem::Specification.new do |s|
  s.version = Decidim::Nav.version
  s.authors = ["Antti Hukkanen"]
  s.email = ["antti.hukkanen@mainiotech.fi"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/mainio/decidim-module-nav"
  s.required_ruby_version = ">= 3.0"

  s.metadata["rubygems_mfa_required"] = "true"

  s.name = "decidim-nav"
  s.summary = "A decidim module for custom navigation."
  s.description = "Customize the main menu on Decidim organizations."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Nav.decidim_version
end

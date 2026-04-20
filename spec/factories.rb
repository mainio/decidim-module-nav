# frozen_string_literal: true

require "decidim/nav/test/factories"
require "decidim/proposals/test/factories"
require "decidim/meetings/test/factories"
require "decidim/accountability/test/factories"
require "decidim/debates/test/factories"
require "decidim/blogs/test/factories"
require "decidim/budgets/test/factories"
require "decidim/sortitions/test/factories"

FactoryBot.define do
  factory :page_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :pages).i18n_name }
    manifest_name { :pages }
    participatory_space { create(:participatory_process, :with_steps, organization:) }
  end

  factory :page, class: "Decidim::Pages::Page" do
    body { Decidim::Faker::Localized.wrapped("<p>", "</p>") { generate_localized_title } }
    component { build(:component, manifest_name: "pages") }
  end
end

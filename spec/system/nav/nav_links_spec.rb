# frozen_string_literal: true

require "spec_helper"

describe "Menu" do
  let!(:organization) { create(:organization, enable_omnipresent_banner: true) }
  let!(:menu_content_block) { create(:content_block, organization:, manifest_name: :global_menu, scope_name: :homepage) }

  before do
    Decidim::Nav::Link.create!(
      navigable_id: organization.id,
      title: { en: "ExampleLink" },
      href: { en: "https://example.org" },
      weight: 1,
      navigable_type: "Decidim::Organization"
    )

    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the the nav link in menu main menu" do
    within ".home__menu" do
      nav_link = Decidim::Nav::Link.first

      link = translated(nav_link.href)
      expect(page).to have_link(translated(nav_link.title, locale: :en), href: link)
    end
  end
end

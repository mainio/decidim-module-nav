# frozen_string_literal: true

require "spec_helper"

describe "Menu" do
  let!(:organization) { create(:organization, enable_omnipresent_banner: true, available_locales: [:en, :fi, :es]) }
  let!(:participatory_space) { create(:participatory_process, :with_steps, organization:) }
  let!(:menu_content_block) { create(:content_block, organization:, manifest_name: :global_menu, scope_name: :homepage) }
  let(:nav_link) { Decidim::Nav::Link.first }
  let(:link) { translated(nav_link.href) }

  before do
    Decidim::Nav::Link.create!(
      navigable_id: organization.id,
      title: { en: "ExampleLink" },
      href: { en: "/processes" },
      weight: 1,
      navigable_type: "Decidim::Organization"
    )

    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the the nav link in menu main menu" do
    within "#menu-bar" do
      expect(page).to have_link(translated(nav_link.title, locale: :en), href: link)
    end
  end

  context "when desktop view" do
    context "when visiting a link" do
      it "underlines the current link" do
        click_on "ExampleLink"

        expect(page).to have_css("a.menu-link.active-link")
      end
    end

    it "underlines the current language" do
      expect(page).to have_css(".simple-locales-container a", count: 3)
      expect(page).to have_css(".simple-locales-container .active-locale", count: 1)
      expect(find(".simple-locales-container .active-locale")["lang"]).to eq("en")
    end
  end

  context "when mobile view" do
    before do
      page.driver.browser.manage.window.resize_to(375, 667)
    end

    it "minimizes the main menu to an icon" do
      expect(page).to have_button("toggle-mobile-menu")
      expect(page).to have_no_link(translated(nav_link.title, locale: :en), href: link)
    end

    context "when main menu icon clicked" do
      it "opens a screen filling menu" do
        find_by_id("toggle-mobile-menu").click

        expect(page).to have_link(translated(nav_link.title, locale: :en), href: link)
      end

      it "shows language selection with current language underlined and search bar in the menu" do
        find_by_id("toggle-mobile-menu").click

        expect(page).to have_css("#mobile-menu .input-search")
        expect(page).to have_css("#mobile-menu .mobile-language .menu-link", count: 3)
        expect(page).to have_css("#mobile-menu .mobile-language .active-locale", count: 1)
        expect(find("#mobile-menu .mobile-language .active-locale")["lang"]).to eq("en")
      end
    end

    context "when visiting a link" do
      it "underlines the current link" do
        find_by_id("toggle-mobile-menu").click

        click_on "ExampleLink"

        find_by_id("toggle-mobile-menu").click
        expect(page).to have_css("a.menu-link.active-link")
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe "Nav Links", type: :system do
  include Decidim::SanitizeHelper

  let(:admin) { create :user, :admin, :confirmed }
  let(:organization) { admin.organization }
  let(:target) { ["Same tab", "New tab"].sample }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user
    visit decidim_admin.root_path
    click_link "Settings"
    click_link "Navigation"
  end

  describe "Managing nav links" do
    it "can create new nav links" do
      click_link "Add"

      within ".new_nav_link " do
        fill_in_i18n :nav_link_title,
                     "#nav_link-title-tabs",
                     en: "My title",
                     es: "Mi título",
                     ca: "títol mon"
        fill_in_i18n :nav_link_href,
                     "#nav_link-href-tabs",
                     en: "http://example.org"
        fill_in "nav_link_weight", with: "1"
        select target, from: "nav_link[target]"

        find("*[type=submit]").click
      end

      expect(page).to have_admin_callout("The link creation succeeded.")
      within "table" do
        expect(page).to have_content("My title")
      end
    end

    context "with existing nav links" do
      let!(:nav_link) { create(:nav_link, navigable: organization) }

      before do
        visit current_path
      end

      it "lists all the links for nav" do
        within "table" do
          expect(page).to have_content(translated(nav_link.title, locale: :en))
          expect(page).to have_content(translated(nav_link.href))
          expect(page).to have_content(nav_link.weight)
        end
      end

      context "when editing a link" do
        before do
          within find("#nav_link_#{nav_link.id}", text: translated(nav_link.title)) do
            click_link "Edit"
          end
        end

        it "keep the existing link attributes" do
          within ".edit_nav_link" do
            expect(page).to have_field("nav_link[title_en]", with: translated(nav_link.title, locale: :en))
            expect(page).to have_field("nav_link[href_en]", with: translated(nav_link.href, locale: :en))
            expect(page).to have_field("Order number", with: nav_link.weight)
          end
        end

        it "can edit them" do
          within ".edit_nav_link " do
            fill_in_i18n :nav_link_title,
                         "#nav_link-title-tabs",
                         en: "Another title",
                         es: "Otro título",
                         ca: "Altre títol"
            fill_in_i18n "nav_link_href",
                         "#nav_link-href-tabs",
                         en: "http://another-example.org"
            fill_in "nav_link_weight", with: "9"
            select target, from: "nav_link[target]"

            find("*[type=submit]").click
          end

          expect(page).to have_admin_callout("The link update succeeded.")

          within "table" do
            expect(page).to have_content("Another title")
            expect(page).not_to have_content(translated(nav_link.title, locale: :en))
          end
        end
      end

      it "can delete them" do
        within find("#nav_link_#{nav_link.id}", text: translated(nav_link.title)) do
          accept_confirm { click_link "Delete" }
        end
        expect(page).to have_admin_callout("The link deletion succeeded.")
        within ".card-section" do
          expect(page).to have_content("No links available.")
        end
      end
    end
  end
end

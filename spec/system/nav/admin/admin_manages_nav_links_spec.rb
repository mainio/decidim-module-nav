# frozen_string_literal: true

require "spec_helper"

describe "Nav Links", type: :system do
  include Decidim::SanitizeHelper

  let(:admin) { create(:user, :admin, :confirmed) }
  let(:organization) { admin.organization }
  let(:target) { %w(link_target_blank link_target_).sample }

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
        fill_in "nav_link[title_en]", with: "My title"
        fill_in "nav_link[href_en]", with: "http://example.org"
        fill_in "nav_link[weight]", with: "1"
        select target == "link_target_blank" ? "New tab" : "Same tab", from: "nav_link[target]"
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
          within "#nav_link_#{nav_link.id}", text: translated(nav_link.title) do
            click_link "Edit"
          end
        end

        it "keep the existing link attributes" do
          within ".edit_nav_link" do
            expect(page).to have_field("nav_link[title_en]", with: translated(nav_link.title, locale: :en))
            expect(page).to have_field("nav_link[href_en]", with: translated(nav_link.href, locale: :en))
            expect(page).to have_field("nav_link[weight]", with: nav_link.weight)
          end
        end

        it "can edit them" do
          within ".edit_nav_link " do
            fill_in "nav_link[title_en]", with: "Another title"
            fill_in "nav_link[href_en]", with: "http://another-example.org"
            fill_in "nav_link[weight]", with: "9"
            select target == "link_target_blank" ? "New tab" : "Same tab", from: "nav_link[target]"
            find("*[type=submit]").click
          end

          expect(page).to have_admin_callout("The link update succeeded.")

          within "table" do
            expect(page).to have_content("Another title")
            expect(page).to have_no_content(translated(nav_link.title, locale: :en))
          end
        end
      end

      it "can delete them" do
        within "#nav_link_#{nav_link.id}", text: translated(nav_link.title) do
          accept_confirm { click_link "Delete" }
        end
        expect(page).to have_admin_callout("The link deletion succeeded.")
        within "#nav_links" do
          expect(page).to have_content("No links available.")
        end
      end
    end
  end
end

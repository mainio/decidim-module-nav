# frozen_string_literal: true

require "spec_helper"

describe "Breadcrumbs", versioning: true do
  context "with a component" do
    include_context "with a component"

    let!(:organization) { create(:organization, enable_omnipresent_banner: true, available_locales: [:en, :ca, :es]) }
    let!(:user) { create(:user, :confirmed, organization:) }
    let!(:process) { create(:participatory_process, :with_steps, organization:) }

    before do
      switch_to_host(organization.host)
    end

    context "when in proposal version page" do
      let(:manifest_name) { "proposals" }
      let!(:proposal) { create(:proposal, title: { en: "Proposal title" }, component:) }

      before do
        visit_component

        click_on translated_attribute(proposal.title)
        click_on "see other versions"
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 6)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(proposal.title))
          expect(page).to have_content("Version number 1")
        end
      end
    end

    context "when in meeting version page" do
      let(:manifest_name) { "meetings" }
      let!(:meeting) { create(:meeting, :published, title: { en: "Meeting title" }, component:) }

      before do
        visit_component

        click_on translated_attribute(meeting.title)
        click_on "see other versions"
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 6)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(meeting.title))
          expect(page).to have_content("Version number 1")
        end
      end
    end

    context "when in result version page" do
      let(:manifest_name) { "accountability" }
      let!(:result) { create(:result, title: { en: "Result title" }, component:) }
      let!(:category) { create(:category, participatory_space:) }

      before do
        result.update!(category:)
        visit_component

        within ".accountability__grid" do
          find(".accountability__status-title").click
        end

        click_on translated_attribute(result.title)
      end

      it "shows full breadcrumbs" do
        click_on "see other versions"

        expect(page).to have_css("ul.breadcrumbs li", count: 6)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(result.title))
          expect(page).to have_content("Version number 1")
        end
      end

      context "when result has a subresult" do
        let!(:sub_result) { create(:result, title: { en: "Subresult title" }, component:, parent: result) }

        it "adds 1 more layer to breadcrumbs" do
          refresh
          click_on translated_attribute(sub_result.title)

          click_on "see other versions"

          expect(page).to have_css("ul.breadcrumbs li", count: 7)

          within ".breadcrumbs" do
            expect(page).to have_content(translated(sub_result.title))
            expect(page).to have_content("Version number 1")
          end
        end
      end
    end

    context "when in debate version page" do
      let(:manifest_name) { "debates" }
      let!(:debate) { create(:debate, title: { en: "Debate title" }, component:) }

      before do
        visit_component

        click_on translated_attribute(debate.title)
        click_on "see other versions"
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 6)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(debate.title))
          expect(page).to have_content("Version number 1")
        end
      end
    end

    context "when in blog post page" do
      let(:manifest_name) { "blogs" }
      let!(:post) { create(:post, title: { en: "Post title" }, component:) }

      before do
        visit_component

        click_on translated_attribute(post.title)
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 5)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(post.title))
        end
      end
    end

    context "when in budget page" do
      let(:manifest_name) { "budgets" }
      let!(:budget) { create(:budget, title: { en: "Budget title" }, component:) }
      let!(:project) { create(:project, title: { en: "Project title" }, budget:) }

      before do
        visit_component

        click_on translated_attribute(project.title)
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 6)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(budget.title))
          expect(page).to have_content(translated(project.title))
        end
      end
    end

    context "when in sortition page" do
      let(:manifest_name) { "sortitions" }
      let!(:sortition) { create(:sortition, title: { en: "Sortition title" }, component:) }

      before do
        visit_component

        click_on translated_attribute(sortition.title)
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 5)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(sortition.title))
        end
      end
    end

    context "when in page -page" do
      let(:manifest_name) { "pages" }
      let!(:page_component) { create(:page, component:, body: { en: "Page body" }) }

      before do
        visit_component
      end

      it "shows full breadcrumbs" do
        expect(page).to have_css("ul.breadcrumbs li", count: 4)

        within ".breadcrumbs" do
          expect(page).to have_content(translated(page_component.title))
        end
      end
    end
  end

  context "when in account page" do
    let!(:organization) { create(:organization, enable_omnipresent_banner: true, available_locales: [:en, :ca, :es]) }
    let!(:user) { create(:user, :confirmed, organization:) }

    before do
      switch_to_host(organization.host)
      sign_in user
      visit decidim.account_path
    end

    it "shows full breadcrumbs" do
      expect(page).to have_css("ul.breadcrumbs li", count: 2)

      within ".breadcrumbs" do
        expect(page).to have_content("My account")
      end
    end
  end

  context "when not signed in" do
    let!(:organization) { create(:organization, enable_omnipresent_banner: true, available_locales: [:en, :ca, :es]) }

    before do
      switch_to_host(organization.host)
    end

    it "shows full breadcrumbs on registration page" do
      visit decidim.new_user_registration_path
      expect(page).to have_css("ul.breadcrumbs li", count: 2)

      within ".breadcrumbs" do
        expect(page).to have_content("Sign up")
      end
    end

    it "shows full breadcrumbs on 'Forgot your password' -page" do
      visit decidim.new_user_password_path
      expect(page).to have_css("ul.breadcrumbs li", count: 2)

      within ".breadcrumbs" do
        expect(page).to have_content("Forgot your password?")
      end
    end

    it "shows full breadcrumbs on 'Confirmation instructions' -page" do
      visit decidim.new_user_confirmation_path
      expect(page).to have_css("ul.breadcrumbs li", count: 2)

      within ".breadcrumbs" do
        expect(page).to have_content("Resend confirmation instructions")
      end
    end

    it "shows full breadcrumbs on 'Unlock instructions' -page" do
      visit decidim.new_user_unlock_path
      expect(page).to have_css("ul.breadcrumbs li", count: 2)

      within ".breadcrumbs" do
        expect(page).to have_content("Resend unlock instructions")
      end
    end
  end
end

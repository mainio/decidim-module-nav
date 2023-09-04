# frozen_string_literal: true

require "spec_helper"

describe "Menu", type: :system do
  let(:organization) { create(:organization) }
  let!(:nav_link) { create(:nav_link, organization: organization) }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  it "renders the the nav link in menu main menu" do
    within ".main-nav" do
      link = "/link?external_url=#{ERB::Util.url_encode(translated(nav_link.href))}"
      expect(page).to have_link(translated(nav_link.title, locale: :en), href: link)
    end
  end
end

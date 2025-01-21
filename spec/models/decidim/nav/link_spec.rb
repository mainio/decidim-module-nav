# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    describe Link do
      subject { nav_link }

      let(:organization) { create(:organization) }
      let(:nav_link) { build(:nav_link, navigable: organization) }

      it "has an association for organisation" do
        expect(subject.organization).to eq(organization)
      end

      describe "validations" do
        context "when has organization" do
          it "is valid" do
            expect(subject).to be_valid
          end
        end

        context "when doesn't have a organization" do
          let(:nav_link) { build(:nav_link) }

          it "is not valid without an organisation" do
            expect(subject).not_to be_valid
          end
        end
      end
    end
  end
end

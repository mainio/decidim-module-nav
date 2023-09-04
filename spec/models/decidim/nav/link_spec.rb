# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    describe Link do
      subject { nav_link }

      let(:organization) { build(:organization) }
      let(:nav_link) { build(:nav_link, organization: organization) }

      it "has an association for organisation" do
        expect(subject.organization).to eq(organization)
      end

      describe "validations" do
        it "is valid" do
          expect(subject).to be_valid
        end

        it "is not valid without an organisation" do
          subject.organization = nil
          expect(subject).not_to be_valid
        end
      end
    end
  end
end

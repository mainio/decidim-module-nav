# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    module Admin
      describe LinkForm do
        subject { described_class.from_params(attributes).with_context(context) }

        let(:title) do
          {
            en: "title",
            es: "title",
            ca: "title"
          }
        end
        let(:href) { { en: "https://decidim.org/" } }
        let(:weight) { (1..5).to_a.sample }
        let(:organization) { create(:organization) }
        let(:target) { ["blank", ""].sample }

        let(:attributes) do
          {
            "title" => title,
            "href" => href,
            "target" => target,
            "weight" => weight

          }
        end
        let(:context) do
          {
            "current_organization" => organization
          }
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "when name is missing" do
          let(:title) { nil }

          it { is_expected.to be_invalid }
        end

        context "when href is missing" do
          let(:href) { nil }

          it { is_expected.to be_invalid }
        end

        context "when weight is missing" do
          let(:weight) { nil }

          it { is_expected.to be_invalid }
        end
      end
    end
  end
end

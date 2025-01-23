# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    module Admin
      describe CreateLink do
        subject { described_class.new(form) }

        let(:nav_link) { create(:nav_link, navigable: organization) }
        let(:organization) { create(:organization) }
        let(:title) { Decidim::Faker::Localized.word }
        let(:href) { Decidim::Faker::Localized.literal(::Faker::Internet.url) }
        let(:weight) { (1..10).to_a.sample }
        let(:target) { ["blank", ""].sample }

        let(:form) do
          double(
            invalid?: invalid,
            title:,
            href:,
            weight:,
            target:,
            organization:,
            parent_id: nav_link.id,
            navigable: organization,
            current_page_rules: [
              Decidim::Nav::Admin::LinkRuleForm.new(
                value: "Example rule",
                rule_type: 0,
                source: 0,
                position: 0,
                operator: 1
              )
            ]
          )
        end
        let(:invalid) { false }

        context "when the form is not valid" do
          let(:invalid) { true }

          it "is not valid" do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context "when the form is valid" do
          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    module Admin
      describe UpdateLink do
        subject { described_class.new(form, nav_link) }

        let(:nav_link) { create :nav_link }
        let(:organization) { create :organization }
        let(:title) { Decidim::Faker::Localized.literal("New title") }
        let(:href) { Decidim::Faker::Localized.literal(::Faker::Internet.url) }
        let(:weight) { (1..10).to_a.sample }
        let(:target) { ["blank", ""].sample }

        let(:form) do
          double(
            invalid?: invalid,
            title: title,
            href: href,
            weight: weight,
            target: target,
            organization: organization
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
          before do
            subject.call
            nav_link.reload
          end

          it "updates the link title" do
            expect(nav_link.title).to eq(Decidim::Faker::Localized.literal("New title"))
          end

          it "updates the link URL" do
            expect(nav_link.href).to eq(href)
          end
        end
      end
    end
  end
end

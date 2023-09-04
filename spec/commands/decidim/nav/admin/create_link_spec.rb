# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Nav
    module Admin
      describe CreateLink do
        subject { described_class.new(form) }

        let(:organization) { create :organization }
        let(:title) { Decidim::Faker::Localized.word }
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
          it "broadcasts ok" do
            expect { subject.call }.to broadcast(:ok)
          end
        end
      end
    end
  end
end

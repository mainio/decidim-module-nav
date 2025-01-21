# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :nav_link, class: "Decidim::Nav::Link" do
    title { generate_localized_title }
    href { Decidim::Faker::Localized.literal(Faker::Internet.url) }
    target { ["blank", ""].sample }
    weight { (1..10).to_a.sample }
  end
end

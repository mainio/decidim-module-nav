# frozen_string_literal: true

module Decidim
  module Nav
    class Link < ApplicationRecord
      belongs_to :parent, class_name: "Decidim::Nav::Link", optional: true
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"
      has_many :children, foreign_key: :parent_id, class_name: "Decidim::Nav::Link", inverse_of: :parent, dependent: :destroy

      scope :with_organization, ->(organization) { where(organization: organization) }
      scope :top_level, -> { where(parent: nil) }
      scope :ordered, -> { order(:weight) }
    end
  end
end

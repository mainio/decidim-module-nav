# frozen_string_literal: true

module Decidim
  module Nav
    class Link < ApplicationRecord
      belongs_to :parent, class_name: "Decidim::Nav::Link", optional: true
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"
      has_many :children, -> { ordered }, foreign_key: :parent_id, class_name: "Decidim::Nav::Link", inverse_of: :parent, dependent: :destroy
      has_many :rules, -> { ordered }, foreign_key: :decidim_nav_link_id, class_name: "Decidim::Nav::LinkRule", inverse_of: :link, dependent: :destroy

      scope :with_organization, ->(organization) { where(organization: organization) }
      scope :top_level, -> { where(parent: nil) }
      scope :ordered, -> { order(:weight) }

      def top_level?
        parent_id.nil?
      end

      def current?(url, locale: nil)
        return false unless url

        current_page_rules = rules.current_page
        return current_page_rules.all? { |r| r.match?(url) } if current_page_rules.any?

        # Fall back to exact path match if there are no rules defined.
        uri = URI.parse(url)
        link_href = URI.parse(active_href(locale))
        uri.path == link_href.path
      end

      def active_href(locale = nil)
        locale ||= I18n.locale

        href[locale.to_s].presence || href[organization.default_locale]
      end
    end
  end
end

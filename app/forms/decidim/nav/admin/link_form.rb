# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # A form object to create or update nav links.
      class LinkForm < Form
        include TranslatableAttributes

        mimic :nav_link

        translatable_attribute :title, String
        translatable_attribute :href, String
        attribute :parent_id, Integer
        attribute :weight, Integer
        attribute :target, String
        attribute :current_page_rules, [Decidim::Nav::Admin::LinkRuleForm]

        validates :title, translatable_presence: true
        validates :href, translatable_presence: true
        validates :weight, presence: true

        validate :validate_link_parent_organization

        alias organization current_organization

        def map_model(model)
          self.current_page_rules = model.rules.current_page.map do |rule|
            Decidim::Nav::Admin::LinkRuleForm.from_model(rule)
          end
        end

        private

        def validate_link_parent_organization
          return if parent_id.blank?

          errors.add(:parent_id, :invalid) unless Link.with_organization(current_organization).exists?(parent_id)
        end
      end
    end
  end
end

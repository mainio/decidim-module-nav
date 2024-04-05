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
        validates :weight, :navigable, presence: true

        validate :validate_link_parent_context

        def map_model(model)
          self.current_page_rules = model.rules.current_page.map do |rule|
            Decidim::Nav::Admin::LinkRuleForm.from_model(rule)
          end
        end

        def navigable
          context[:navigable]
        end

        private

        def validate_link_parent_context
          return if parent_id.blank?

          errors.add(:parent_id, :invalid) if navigable.blank? || !Link.with_navigable(navigable).exists?(parent_id)
        end
      end
    end
  end
end

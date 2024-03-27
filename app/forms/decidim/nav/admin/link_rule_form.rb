# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # A form object to create or update nav link rules.
      class LinkRuleForm < Form
        mimic :nav_link_rule

        attribute :value, String
        attribute :rule_type, Integer
        attribute :source, Integer
        attribute :position, Integer
        attribute :operator, Integer
        attribute :deleted, Boolean, default: false

        def to_param
          return id if id.present?

          "nav-link-rule-id"
        end
      end
    end
  end
end

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

        def map_model(rule)
          # Map the literal enum values to their integer values as expected
          # by the form.
          self.rule_type = Decidim::Nav::LinkRule.rule_types[rule.rule_type]
          self.source = Decidim::Nav::LinkRule.sources[rule.source]
          self.operator = Decidim::Nav::LinkRule.operators[rule.operator]
        end

        def to_param
          return id if id.present?

          "nav-link-rule-id"
        end
      end
    end
  end
end

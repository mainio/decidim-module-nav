# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # A form object to create or update scopes.
      class LinkForm < Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :href, String
        attribute :weight, Integer
        attribute :target, String

        validates :title, translatable_presence: true
        validates :href, translatable_presence: true
        validates :weight, presence: true

        alias organization current_organization
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # Helpers for the links management views
      module LinksHelper
        def target_options
          i18n_scope = "activemodel.attributes.nav_link.target_options"
          [
            [t("same_tab", scope: i18n_scope), ""],
            [t("new_tab", scope: i18n_scope), "blank"]
          ]
        end
      end
    end
  end
end

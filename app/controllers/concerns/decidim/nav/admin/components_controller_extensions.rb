# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      module ComponentsControllerExtensions
        extend ActiveSupport::Concern

        include Decidim::Admin::IconLinkHelper

        included do
          helper_method :icon_link_to

          private

          alias_method :icon_link_to_orig, :icon_link_to unless private_method_defined?(:icon_link_to_orig)

          delegate :link_to, :content_tag, :_icon_classes, :asset_pack_path, :with_tooltip, :icon, to: :helpers

          def icon_link_to(icon_name, url, ...)
            extra = nil
            if icon_name == "settings-4-line" && respond_to?(:component_links_path)
              # Add the link to the links management after the cog icon
              # extra = icon_link_to_orig()
              match = url.match(%r{/([0-9]+)/edit(\?.*)?$})
              extra = icon_link_to_orig(
                "globe-line",
                component_links_path(component_id: match[1]),
                t("actions.links", scope: "decidim.admin"),
                class: "action-icon--links"
              )
            end
            helpers.safe_join(
              [
                icon_link_to_orig(icon_name, url, ...),
                extra
              ]
            )
          end
        end
      end
    end
  end
end

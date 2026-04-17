# frozen_string_literal: true

module Decidim
  module Nav
    module VersionsControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

        before_action :set_controller_breadcrumb

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items.concat(breadcrumb_item)
        end

        def breadcrumb_item
          return [] unless versioned_resource

          items = []

          if versioned_resource.is_a?(Decidim::Accountability::Result) && versioned_resource&.parent.present?
            items << {
              label: translated_attribute(versioned_resource.parent.title),
              url: versioned_resource_path(versioned_resource.parent),
              active: true
            }
          end

          items << {
            label: translated_attribute(versioned_resource.title),
            url: versioned_resource_path(versioned_resource),
            active: true
          }

          items << {
            label: t("version", scope: "decidim.versions.resource_version", number: params[:id]),
            url: request.path,
            active: true
          }
        end

        def versioned_resource_path(versioned_resource)
          case versioned_resource
          when Decidim::Proposals::ProposalPresenter
            proposal_path(versioned_resource)
          when Decidim::Accountability::Result
            result_path(versioned_resource)
          when Decidim::Meetings::Meeting
            meeting_path(versioned_resource)
          when Decidim::Debates::DebatePresenter
            debate_path(versioned_resource)
          end
        end
      end
    end
  end
end

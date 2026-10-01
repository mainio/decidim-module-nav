# frozen_string_literal: true

module Decidim
  module Nav
    module ResultsControllerExtensions
      extend ActiveSupport::Concern

      included do
        def set_controller_breadcrumb
          controller_breadcrumb_items.concat(breadcrumb_item)
        end

        def breadcrumb_item
          return [] unless result

          items = []

          if result&.parent.present?
            items << {
              label: translated_attribute(result.parent.title),
              url: result_path(result.parent),
              active: true
            }
          end

          items << {
            label: translated_attribute(result.title),
            url: result_path(result),
            active: true
          }

          items
        end
      end
    end
  end
end

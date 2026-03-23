# frozen_string_literal: true

module Decidim
  module Nav
    module SortitionsControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

        before_action :set_controller_breadcrumb

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items << breadcrumb_item
        end

        def breadcrumb_item
          return {} unless sortition

          {
            label: translated_attribute(sortition.title),
            url: sortition_path(sortition),
            active: true
          }
        end
      end
    end
  end
end

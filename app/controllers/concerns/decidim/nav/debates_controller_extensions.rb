# frozen_string_literal: true

module Decidim
  module Nav
    module DebatesControllerExtensions
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
          return {} unless debate

          {
            label: translated_attribute(debate.title),
            url: debate_path(debate),
            active: true
          }
        end
      end
    end
  end
end

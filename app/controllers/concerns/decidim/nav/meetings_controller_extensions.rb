# frozen_string_literal: true

module Decidim
  module Nav
    module MeetingsControllerExtensions
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
          return {} unless meeting

          {
            label: translated_attribute(meeting.title),
            url: meeting_path(meeting),
            active: true
          }
        end
      end
    end
  end
end

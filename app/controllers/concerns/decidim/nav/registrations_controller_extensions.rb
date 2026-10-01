# frozen_string_literal: true

module Decidim
  module Nav
    module RegistrationsControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :set_controller_breadcrumb

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items << breadcrumb_item
        end

        def breadcrumb_item
          {
            label: t("devise.registrations.new.sign_up"),
            url: request.path,
            active: true
          }
        end
      end
    end
  end
end

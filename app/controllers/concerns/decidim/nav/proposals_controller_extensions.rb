# frozen_string_literal: true

module Decidim
  module Nav
    module ProposalsControllerExtensions
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
          return {} unless @proposal

          {
            label: translated_attribute(@proposal.title),
            url: proposal_path(@proposal),
            active: true
          }
        end
      end
    end
  end
end

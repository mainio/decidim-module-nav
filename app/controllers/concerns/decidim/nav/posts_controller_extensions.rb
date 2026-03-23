# frozen_string_literal: true

module Decidim
  module Nav
    module PostsControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

        # rubocop:disable Rails/LexicallyScopedActionFilter
        before_action :set_controller_breadcrumb, only: [:show]
        # rubocop:enable Rails/LexicallyScopedActionFilter

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items << breadcrumb_item
        end

        def breadcrumb_item
          return {} unless post

          {
            label: translated_attribute(post.title),
            url: post_path(post),
            active: true
          }
        end
      end
    end
  end
end

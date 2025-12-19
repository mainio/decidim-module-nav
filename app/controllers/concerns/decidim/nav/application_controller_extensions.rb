# frozen_string_literal: true

module Decidim
  module Nav
    module ApplicationControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :nav_javascript
        helper_method :breadcrumbs

        private

        def add_breadcrumb(title, url)
          breadcrumbs << [title, url]
        end

        def breadcrumbs
          @breadcrumbs ||= []
        end

        def nav_javascript
          snippets.add(:foot, view_context.javascript_pack_tag("decidim_nav_header"))
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    module ApplicationControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :nav_javascript
      end

      private

      def nav_javascript
        snippets.add(:foot, view_context.javascript_pack_tag("decidim_nav_header"))
      end
    end
  end
end

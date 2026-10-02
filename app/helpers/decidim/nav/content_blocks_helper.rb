# frozen_string_literal: true

module Decidim
  module Nav
    module ContentBlocksHelper
      def show_menu?
        links? && !(global_menu? && controller_name == "homepage")
      end

      def global_menu?
        current_content_blocks.exists?(manifest_name: "global_menu")
      end

      def links?
        current_links.any?
      end

      private

      def current_content_blocks
        @content_blocks ||= Decidim::ContentBlock.for_scope(
          :homepage,
          organization: current_organization
        ).published
      end

      def current_links
        @links ||= Decidim::Nav::Link
                   .includes(:navigable)
                   .select { |link| link.organization == current_organization }
      end
    end
  end
end

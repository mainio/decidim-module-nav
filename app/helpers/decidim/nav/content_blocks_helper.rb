# frozen_string_literal: true

module Decidim
  module Nav
    module ContentBlocksHelper
      def global_menu?
        current_content_blocks.any? { |block| block.manifest_name == "global_menu" }
      end

      private

      def current_content_blocks
        @content_blocks ||= Decidim::ContentBlock.for_scope(
          :homepage,
          organization: current_organization
        ).published
      end
    end
  end
end

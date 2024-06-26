# frozen_string_literal: true

module Decidim
  module Nav
    # Overridden to add the role to the main nav
    module MenuPresenterExtensions
      extend ActiveSupport::Concern

      included do
        def render
          content_tag :nav, class: "main-nav", "aria-label": @options.fetch(:label, nil) do
            render_menu
          end
        end
      end
    end
  end
end

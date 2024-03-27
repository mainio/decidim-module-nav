# frozen_string_literal: true

module Decidim
  module Nav
    class SubmenuPresenter < Decidim::MenuPresenter
      def render(&block)
        render_menu(&block)
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    class SubmenuPresenter < Decidim::MenuPresenter
      def render(&)
        render_menu(&)
      end
    end
  end
end

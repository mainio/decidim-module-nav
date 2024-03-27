# frozen_string_literal: true

require "decidim/nav/admin"
require "decidim/nav/engine"
require "decidim/nav/admin_engine"

module Decidim
  # This namespace holds the logic for the Nav module.
  module Nav
    autoload :MenuBuilder, "decidim/nav/menu_builder"
    autoload :SubmenuPresenter, "decidim/nav/submenu_presenter"
  end
end

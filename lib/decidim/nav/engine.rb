# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Nav
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Nav

      initializer "decidim_nav.add_cells_view_paths", before: "decidim_core.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Nav::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Nav::Engine.root}/app/views")
      end

      initializer "decidim_nav.menu" do
        config.after_initialize do
          builder = Decidim::Nav::MenuBuilder.new
          builder.build
        end
      end

      initializer "decidim_nav.add_customizations", before: "decidim_comments.query_extensions" do
        config.to_prepare do
          # Presenter extensions
          Decidim::MenuPresenter.include(Decidim::Nav::MenuPresenterExtensions)
          Decidim::MenuItemPresenter.include(Decidim::Nav::MenuItemPresenterExtensions)

          # Cell extensions
          Decidim::ContentBlocks::GlobalMenuCell.include(Cell::ViewModel::Partial)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    # This is the engine that runs on the admin interface of the nav module.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Nav::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :links
        root to: "links#index"
      end

      initializer "decidim_nav_admin.mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::Nav::AdminEngine, at: "/admin", as: :decidim_admin_nav
        end
      end

      initializer "decidim_nav_admin.view_hooks" do
        Decidim.menu :admin_settings_menu do |menu|
          menu.add_item :nav,
                        t("menu.nav", scope: "decidim_nav.admin"),
                        decidim_admin_nav.links_path,
                        position: 1.25,
                        active: is_active_link?(decidim_admin_nav.links_path),
                        if: allowed_to?(:update, :organization, organization: current_organization)
        end
      end

      def load_seed
        nil
      end
    end
  end
end

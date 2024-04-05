# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      class ComponentLinksController < Decidim::Admin::ApplicationController
        # include Decidim::Admin::ParticipatorySpaceAdminContext
        # include Decidim::ParticipatoryProcesses::Admin::Concerns::ParticipatoryProcessAdmin
        include Decidim::ComponentPathHelper
        include Decidim::Nav::Admin::HasLinks

        layout :layout

        helper_method :current_participatory_space, :links_path, :link_path, :new_link_path, :edit_link_path

        def permission_class_chain
          space_permissions = PermissionsRegistry.chain_for(Decidim::ParticipatoryProcesses::Admin::Concerns::ParticipatoryProcessAdmin)
          [Decidim::Nav::Admin::Permissions] + space_permissions + super
        end

        private

        def layout
          current_participatory_space.manifest.context(:admin).layout
        end

        def links_path
          routes.component_links_path(navigable)
        end

        def link_path(link)
          routes.component_link_path(navigable, link)
        end

        def new_link_path
          routes.new_component_link_path(navigable)
        end

        def edit_link_path(link)
          routes.edit_component_link_path(navigable, link)
        end

        def routes
          @routes ||= ::Decidim::EngineRouter.admin_proxy(current_participatory_space)
        end

        def navigable
          @navigable ||= current_participatory_space.components.find(params[:component_id])
        end

        def organization_processes
          @organization_processes ||= OrganizationParticipatoryProcesses.new(current_organization).query
        end

        def current_participatory_space
          @current_participatory_space ||=
            request.env["current_participatory_space"] ||
            organization_processes.find_by!(slug: params[:participatory_process_slug])
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      class LinksController < Nav::Admin::ApplicationController
        layout "decidim/admin/settings"
        helper_method :link

        def index
          enforce_permission_to :index, :nav_link
          @links = Link.with_organization(current_organization)
        end

        def new
          enforce_permission_to :new, :nav_link
          @form = form(Decidim::Nav::Admin::LinkForm).instance
        end

        def create
          enforce_permission_to :new, :nav_link
          @form = form(Decidim::Nav::Admin::LinkForm).from_params(params)

          Decidim::Nav::Admin::CreateLink.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("nav.links.create.success", scope: "decidim.admin")
              redirect_to links_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("nav.links.create.error", scope: "decidim.admin")
              render :new
            end
          end
        end

        def edit
          enforce_permission_to :update, :nav_link, nav_link: link
          @form = form(Decidim::Nav::Admin::LinkForm).from_model(link)
        end

        def update
          enforce_permission_to :update, :nav_link, nav_link: link
          @form = form(Decidim::Nav::Admin::LinkForm).from_params(params)

          Decidim::Nav::Admin::UpdateLink.call(@form, link) do
            on(:ok) do
              flash[:notice] = I18n.t("nav.links.update.success", scope: "decidim.admin")
              redirect_to links_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("nav.links.update.error", scope: "decidim.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :nav_link
          link.destroy!

          flash[:notice] = I18n.t("nav.links.destroy.success", scope: "decidim.admin")

          redirect_to links_path
        end

        private

        def link
          @link = Decidim::Nav::Link.find(params[:id])
        end
      end
    end
  end
end

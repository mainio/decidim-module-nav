# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      class LinksController < Nav::Admin::ApplicationController
        include Decidim::TranslatableAttributes

        layout "decidim/admin/settings"
        helper_method :link, :link_parent_options, :blank_rule

        def index
          enforce_permission_to :index, :nav_link
          @links = links_scope.top_level.order(:weight)
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
          @link = links_scope.find(params[:id])
        end

        def links_scope
          @links_scope ||= Decidim::Nav::Link.with_organization(current_organization)
        end

        def link_parent_options
          @link_parent_options ||= generate_link_options(links_scope.top_level)
        end

        def generate_link_options(collection, level: 0)
          [].tap do |options|
            collection.order(:weight).each do |link|
              prefix = "-" * level
              options << ["#{prefix} #{translated_attribute(link.title)}".strip, link.id]
              generate_link_options(link.children, level: level + 1).each do |sub|
                options << sub
              end
            end
          end
        end

        def blank_rule
          @blank_rule ||= Decidim::Nav::Admin::LinkRuleForm.new
        end
      end
    end
  end
end

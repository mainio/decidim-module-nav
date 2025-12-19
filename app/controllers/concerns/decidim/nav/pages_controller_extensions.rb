# frozen_string_literal: true

module Decidim
  module Nav
    module PagesControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::ApplicationHelper

        before_action :set_breadcrumbs

        def set_breadcrumbs
          return unless respond_to?(:add_breadcrumb, true)

          add_breadcrumb(t("decidim.menu.home"), decidim.root_path)
          add_breadcrumb(t("decidim.menu.help"), decidim.pages_path)
          add_breadcrumb(translated_attribute(current_organization.static_pages.find_by!(slug: params[:id]).title), decidim.page_path(params[:id])) if params[:id]
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    module PagesControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

        def index
          enforce_permission_to :read, :public_page
          @topics = StaticPageTopic.where(organization: current_organization)
          @orphan_pages = StaticPage.where(topic: nil, organization: current_organization)

          set_controller_breadcrumb
        end

        def show
          @page = current_organization.static_pages.find_by!(slug: params[:id])
          enforce_permission_to :read, :public_page, page: @page
          @topic = @page.topic
          @pages = @topic&.pages

          set_controller_breadcrumb
        end

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items.concat(breadcrumb_item)
        end

        def breadcrumb_item
          items = []

          items << {
            label: t("decidim.pages.index.title"),
            url: pages_path,
            active: true
          }

          if @page
            items << {
              label: translated_attribute(@page.title),
              url: page_path(@page),
              active: true
            }
          end

          items
        end
      end
    end
  end
end

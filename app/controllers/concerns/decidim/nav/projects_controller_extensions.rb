# frozen_string_literal: true

module Decidim
  module Nav
    module ProjectsControllerExtensions
      extend ActiveSupport::Concern

      included do
        include Decidim::TranslatableAttributes

        before_action :set_controller_breadcrumb

        def controller_breadcrumb_items
          @controller_breadcrumb_items ||= []
        end

        def set_controller_breadcrumb
          controller_breadcrumb_items.concat(breadcrumb_item)
        end

        def breadcrumb_item
          return [] unless budget

          items = []

          items << {
            label: translated_attribute(budget.title),
            url: budget_projects_path(budget),
            active: true
          }

          if project
            items << {
              label: translated_attribute(project.title),
              url: budget_project_path(budget, project),
              active: true
            }
          end

          items
        end
      end
    end
  end
end

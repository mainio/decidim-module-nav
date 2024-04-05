# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      class LinksController < Nav::Admin::ApplicationController
        include Decidim::Nav::Admin::HasLinks

        layout "decidim/admin/settings"

        private

        def navigable
          current_organization
        end
      end
    end
  end
end

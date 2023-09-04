# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          if permission_action.subject == :nav_link
            if permission_action.scope == :admin && user&.admin?
              allow!
            else
              disallow!
            end
          end

          permission_action
        end
      end
    end
  end
end

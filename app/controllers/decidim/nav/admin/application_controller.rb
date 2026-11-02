# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      # Note that it inherits from `decidim::admin::Components::BaseController`, which
      # override its layout and provide all kinds of useful methods.
      class ApplicationController < Decidim::Admin::ApplicationController
        # rubocop:disable Decidim/EnforcePermissionTo
        def permission_class_chain
          [Decidim::Nav::Admin::Permissions] + super
        end
        # rubocop:enable Decidim/EnforcePermissionTo
      end
    end
  end
end

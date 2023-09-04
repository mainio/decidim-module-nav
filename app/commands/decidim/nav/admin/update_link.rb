# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # A command with all the business logic when updating a nav link.
      class UpdateLink < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form, link)
          @form = form
          @link = link
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_link
          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_link
          @link.update!(attributes)
        end

        def attributes
          {
            title: form.title,
            href: form.href,
            weight: form.weight,
            target: form.target,
            organization: form.organization
          }
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Nav
    module Admin
      # A command with all the business logic when creating a static nav link.
      class CreateLink < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_link
          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_link
          Decidim::Nav::Link.create!(
            title: form.title,
            href: form.href,
            weight: form.weight,
            target: form.target,
            organization: form.organization
          )
        end
      end
    end
  end
end

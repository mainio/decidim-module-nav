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

          transaction do
            create_link
            create_rules
          end

          broadcast(:ok, link)
        end

        private

        attr_reader :form, :link

        def create_link
          @link = Decidim::Nav::Link.create!(
            parent_id: form.parent_id,
            title: form.title,
            href: form.href,
            weight: form.weight,
            target: form.target.presence,
            navigable: form.navigable
          )
        end

        def create_rules
          # Create the rules
          form.current_page_rules.each do |r|
            next if r.deleted?

            attrs = {
              value: r.value,
              rule_type: r.rule_type,
              source: r.source,
              position: r.position,
              operator: r.operator
            }
            link.rules.create!(attrs)
          end
        end
      end
    end
  end
end

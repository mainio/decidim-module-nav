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

          transaction do
            update_link
            update_rules
          end

          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_link
          @link.update!(attributes)
        end

        def attributes
          {
            parent_id: form.parent_id,
            title: form.title,
            href: form.href,
            weight: form.weight,
            target: form.target,
            navigable: form.navigable
          }
        end

        def update_rules
          # Update the rules
          form.current_page_rules.each do |r|
            if r.deleted
              rule = @link.rules.find_by(id: r.id) if r.id.present?
              rule.destroy! if rule
              next
            end

            attrs = {
              value: r.value,
              rule_type: r.rule_type,
              source: r.source,
              position: r.position,
              operator: r.operator
            }
            if r.id.present?
              rule = @link.rules.find(r.id)
              rule.update!(attrs)
            else
              @link.rules.create!(attrs)
            end
          end
        end
      end
    end
  end
end

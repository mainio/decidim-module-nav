# frozen_string_literal: true

module Decidim
  module Nav
    class LinkRule < ApplicationRecord
      belongs_to :link, foreign_key: :decidim_nav_link_id, class_name: "Decidim::Nav::Link"

      enum rule_type: { current_page: 0 }
      enum source: { path: 0 }, _prefix: true
      enum operator: {
        equals: 1,
        not_equals: -1,
        contains: 2,
        not_contains: -2,
        start_with: 3,
        not_start_with: -3,
        end_with: 4,
        not_end_with: -4
      }, _prefix: true

      scope :ordered, -> { order(:position) }

      def match?(data)
        # Currently only path matching is implemented.
        raise NotImplementedError unless source_path?

        uri = URI.parse(data)
        source_string = uri.path

        if operator_equals?
          source_string == value
        elsif operator_not_equals?
          source_string != value
        else
          method, expected = match_test
          source_string.public_send(method, value) == expected
        end
      end

      private

      def match_test
        if operator_contains?
          [:include?, true]
        elsif operator_not_contains?
          [:exclude?, true]
        elsif operator_start_with?
          [:start_with?, true]
        elsif operator_not_start_with?
          [:start_with?, false]
        elsif operator_end_with?
          [:end_with?, true]
        elsif operator_not_end_with?
          [:end_with?, false]
        end
      end
    end
  end
end

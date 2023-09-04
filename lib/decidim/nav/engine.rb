# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Nav
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Nav

      initializer "decidim_nav.menu" do
        config.after_initialize do
          # Overrides the default menu
          Decidim::MenuRegistry.create(:menu)

          # Adds the correct items for the menu
          Decidim.menu :menu do |menu|
            Link.with_organization(current_organization).top_level.ordered.each_with_index do |link, idx|
              menu.add_item "link_#{link.id}".to_sym,
                            translated_attribute(link.title),
                            translated_attribute(link.href),
                            position: idx,
                            active: :exact,
                            target: link.target
            end
          end
        end
      end
    end
  end
end

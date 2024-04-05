# frozen_string_literal: true

module Decidim
  module Nav
    # Handles the menu building with associated submenus.
    class MenuBuilder
      def build
        builder = self
        create_menu(:menu) do
          builder.clear_cache_for(current_organization)
          builder.clear_submenus
          builder.top_level_links_for(current_organization)
        end
      end

      def create_menu(key, &create_links)
        # Overrides the default menu or the previous menu
        Decidim::MenuRegistry.create(key)

        builder = self

        # Adds the correct items for the menu
        Decidim.menu key do |menu|
          links = instance_eval(&create_links)
          links.each_with_index do |link, idx|
            options = {
              position: idx,
              active: link.current?(request.fullpath, locale: current_locale),
              target: link.target
            }

            sublinks = builder.child_links_for(current_organization, link)
            if sublinks.any?
              submenu_key = "submenu_#{link.id}".to_sym
              builder.create_menu(submenu_key) { sublinks }
              options[:submenu] = { target_menu: submenu_key }
            end

            menu.add_item(
              "link_#{link.id}".to_sym,
              translated_attribute(link.title),
              translated_attribute(link.href),
              **options
            )
          end
        end
      end

      # Removes all the old submenu registrations.
      def clear_submenus
        Decidim::MenuRegistry.send(:all).keys.each do |key|
          next unless key.to_s.match?(/^submenu_[0-9]+$/)

          Decidim::MenuRegistry.destroy(key)
        end
      end

      def clear_cache_for(organization)
        return unless @all_links_for

        @all_links_for.delete(organization.id)
      end

      # This is to avoid causing multiple queries to fetch the organization
      # links. This fetches all links at once and the top level and children are
      # fetched from within this set.
      def all_links_for(organization)
        @all_links_for ||= {}
        @all_links_for[organization.id] ||= Link.with_navigable(organization).ordered.includes(:rules)
      end

      # Fetches the top level links from the all links set.
      def top_level_links_for(organization)
        all_links_for(organization).select(&:top_level?)
      end

      # Fetches the child links for the given link from the all links set.
      def child_links_for(organization, link)
        all_links_for(organization).select { |l| l.parent_id == link.id }
      end
    end
  end
end

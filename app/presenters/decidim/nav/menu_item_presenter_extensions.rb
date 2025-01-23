# frozen_string_literal: true

module Decidim
  module Nav
    # Overridden to handle the submenus and fix accessibility issues.
    module MenuItemPresenterExtensions
      extend ActiveSupport::Concern

      included do
        def render
          data = {}
          submenu = @menu_item.submenu
          data[:submenu] = true if submenu

          content_tag(:li, class: link_wrapper_classes, data:) do
            output = [link_to(composed_label, url, link_options)]
            if submenu
              if @view.respond_to?(:simple_menu)
                # Admin-facing submenu
                output.push(@view.send(:simple_menu, **submenu).render)
              else
                # Participant-facing submenu
                submenu_id = "submenu-#{SecureRandom.hex(10)}"

                # The toggle for opening the submenu
                toggle_label = I18n.t("decidim.nav.shared.subnav.open", title: label)
                toggle_label_active = I18n.t("decidim.nav.shared.subnav.close", title: label)
                output.push(
                  content_tag(
                    :button,
                    type: "button",
                    class: "menu-link__toggle",
                    data: { label_active: toggle_label_active },
                    aria: { label: toggle_label, controls: submenu_id, expanded: false }
                  ) { icon("chevron-bottom", role: "img", "aria-hidden": true) }
                )

                options = {
                  element_class: "menu-link",
                  active_class: "menu-link--active",
                  container_options: { id: submenu_id, class: "menu vertical submenu" }
                }
                target_menu = submenu[:target_menu]
                options.merge!(submenu[:options]) if submenu[:options].present?

                presenter = ::Decidim::Nav::SubmenuPresenter.new(target_menu, @view, options)
                output.push(presenter.render)
              end
            end

            safe_join(output)
          end
        end

        private

        def link_options
          if is_active_link?(url, active)
            { aria: { current: "page" } }
          else
            {}
          end
        end
      end
    end
  end
end

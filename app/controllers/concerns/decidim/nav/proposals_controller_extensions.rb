# frozen_string_literal: true

module Decidim
  module Nav
    module ProposalsControllerExtensions
      extend ActiveSupport::Concern

      included do
        before_action :set_breadcrumbs

        def set_breadcrumbs
          return unless respond_to?(:add_breadcrumb, true)

          add_breadcrumb(t("decidim.menu.home"), decidim.root_path)
          add_breadcrumb(t("decidim.menu.processes"), decidim_participatory_processes.participatory_processes_path)
          add_breadcrumb(translated_attribute(current_participatory_space.title), decidim_participatory_processes.participatory_process_path(current_participatory_space))
          add_breadcrumb(translated_attribute(current_component.name), proposals_path)
          add_breadcrumb(translated_attribute(@proposal.title), proposal_path(@proposal)) if @proposal
        end
      end
    end
  end
end

# frozen_string_literal: true

require "spec_helper"

describe Decidim::Nav::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let(:user) { build(:user, :admin, organization:) }
  let(:organization) { build(:organization) }
  let(:permission_action) { Decidim::PermissionAction.new(**action) }
  let(:context) { {} }
  let(:action) do
    { scope:, action: action_name, subject: action_subject }
  end
  let(:action_name) { :foo }
  let(:scope) { :admin }
  let(:action_subject) { :nav_link }

  describe "nav_link" do
    it { is_expected.to be true }

    context "when user is not admin" do
      let(:user) { build(:user, organization:) }

      it { is_expected.to be false }
    end

    context "when user is not present" do
      let(:user) { nil }

      it { is_expected.to be false }
    end

    context "when scope is not admin" do
      let(:scope) { nil }

      it { is_expected.to be false }
    end
  end
end

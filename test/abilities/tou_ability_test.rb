# frozen_string_literal: true

require "test_helper"

class TouAbilityTest < ActiveSupport::TestCase
  class PermittingAbility
    include CanCan::Ability

    def initialize
      can :manage, ChangesetComment
    end
  end

  test "read changeset comments without restrictions" do
    ability = PermittingAbility.new.merge(TouAbility.new(nil))

    [:index, :show].each do |act|
      assert ability.can? act, ChangesetComment
    end
  end

  test "read changeset comments with a restriction" do
    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(nil))

      [:index, :show].each do |act|
        assert ability.cannot? act, ChangesetComment
      end
    end
  end
end

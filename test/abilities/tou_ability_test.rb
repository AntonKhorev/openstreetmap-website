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

  test "read changeset comments with a restriction that activates in the future" do
    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :activates_on => 20.hours.from_now }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(nil))

      [:index, :show].each do |act|
        assert ability.can? act, ChangesetComment
      end
    end
  end

  test "read changeset comments with a restriction that activates in the past" do
    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :activates_on => 20.hours.ago }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(nil))

      [:index, :show].each do |act|
        assert ability.cannot? act, ChangesetComment
      end
    end
  end

  test "read changeset comments with a restriction that requires accepting ToU while not logged in " do
    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :unless_tou_accepted => true }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(nil))

      [:index, :show].each do |act|
        assert ability.cannot? act, ChangesetComment
      end
    end
  end

  test "read changeset comments with a restriction that requires accepting ToU while not accepted ToU" do
    user = create(:user, :tou_agreed => nil)

    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :unless_tou_accepted => true }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(user))

      [:index, :show].each do |act|
        assert ability.cannot? act, ChangesetComment
      end
    end
  end

  test "read changeset comments with a restriction that requires accepting ToU while accepted ToU" do
    user = create(:user, :tou_agreed => 10.hours.ago)

    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :unless_tou_accepted => true }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(user))

      [:index, :show].each do |act|
        assert ability.can? act, ChangesetComment
      end
    end
  end

  test "read changeset comments with a restriction that activates in the past and requires accepting ToU while accepted ToU" do
    user = create(:user, :tou_agreed => 10.hours.ago)

    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments,
                                           :activates_on => 20.hours.ago,
                                           :unless_tou_accepted => true }]) do
      ability = PermittingAbility.new.merge(TouAbility.new(user))

      [:index, :show].each do |act|
        assert ability.can? act, ChangesetComment
      end
    end
  end
end

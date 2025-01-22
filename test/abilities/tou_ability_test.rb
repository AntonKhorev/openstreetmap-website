# frozen_string_literal: true

require "test_helper"

class TouAbilityTest < ActiveSupport::TestCase
  test "read changeset comments without restrictions" do
    ability = TouAbility.new

    assert ability.can?(:read_comments, Changeset)
  end

  test "show map users with a restriction" do
    with_settings(:data_restrictions => [{ :type => :hide_changeset_comments }]) do
      ability = TouAbility.new

      assert ability.cannot?(:read_comments, Changeset)
    end
  end
end

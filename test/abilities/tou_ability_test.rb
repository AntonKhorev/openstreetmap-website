# frozen_string_literal: true

require "test_helper"

class TouAbilityTest < ActiveSupport::TestCase
  test "read changeset comments without restrictions" do
    ability = TouAbility.new

    assert ability.can?(:read_comments, Changeset)
  end
end

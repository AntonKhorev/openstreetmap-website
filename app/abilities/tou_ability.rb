# frozen_string_literal: true

class TouAbility
  include CanCan::Ability

  def initialize
    can :read_comments, Changeset
  end
end

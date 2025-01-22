# frozen_string_literal: true

class TouAbility
  include CanCan::Ability

  def initialize
    can :read_comments, Changeset

    Settings.data_restrictions.each do |restriction|
      cannot :read_comments, Changeset if restriction.type == :hide_changeset_comments
    end
  end
end

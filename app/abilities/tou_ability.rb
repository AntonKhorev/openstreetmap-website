# frozen_string_literal: true

class TouAbility
  include CanCan::Ability

  def initialize(_user)
    Settings.data_restrictions.each do |restriction|
      cannot :manage, ChangesetComment if restriction.type == :hide_changeset_comments
    end
  end
end

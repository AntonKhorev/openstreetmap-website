# frozen_string_literal: true

class TouAbility
  include CanCan::Ability

  def initialize(user)
    now = Time.zone.now
    Settings.data_restrictions.each do |restriction|
      subject = ChangesetComment if restriction.type == :hide_changeset_comments

      next if subject.nil?
      next if restriction.activates_on && restriction.activates_on > now
      next if restriction.unless_tou_accepted && user&.tou_agreed

      cannot :manage, subject
    end
  end
end

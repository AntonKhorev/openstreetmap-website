# frozen_string_literal: true

class TouAbility
  include CanCan::Ability

  def initialize(user)
    now = Time.zone.now
    Settings.data_restrictions.each do |restriction|
      subjects = case restriction.type
                 when :hide_changeset_users
                   [:changeset_user, ChangesetComment]
                 when :hide_changeset_comments
                   ChangesetComment
                 when :hide_changeset_tags
                   ChangesetTag
                 end

      next if subjects.nil?
      next if restriction.activates_on && restriction.activates_on > now
      next if restriction.unless_tou_accepted && user&.tou_agreed
      next if restriction.unless_tou_accepted_after && user&.tou_agreed && user.tou_agreed > restriction.unless_tou_accepted_after

      cannot :manage, subjects
    end
  end
end

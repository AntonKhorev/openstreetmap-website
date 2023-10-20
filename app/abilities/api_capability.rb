# frozen_string_literal: true

class ApiCapability
  include CanCan::Ability

  def initialize(token)
    if Settings.status != "database_offline"
      user = if token.respond_to?(:resource_owner_id)
               User.find(token.resource_owner_id)
             elsif token.respond_to?(:user)
               token.user
             end

      if user&.active?
        can [:create, :comment, :close, :reopen], Note if scope?(token, :write_notes)
        can [:show, :data], Trace if scope?(token, :read_gpx)
        can [:create, :update, :destroy], Trace if scope?(token, :write_gpx)
        can [:details], User if scope?(token, :read_prefs)
        can [:gpx_files], User if scope?(token, :read_gpx)
        can [:index, :show], UserPreference if scope?(token, :read_prefs)
        can [:update, :update_all, :destroy], UserPreference if scope?(token, :write_prefs)

        if user.terms_agreed? && scope?(token, :write_api)
          can [:create, :update, :upload, :close, :subscribe, :unsubscribe], Changeset
          can :create, ChangesetComment
          can [:create, :update, :delete], Node
          can [:create, :update, :delete], Way
          can [:create, :update, :delete], Relation
        end

        if user.moderator?
          can [:destroy, :restore], ChangesetComment if scope?(token, :write_api)
          can :destroy, Note if scope?(token, :write_notes)
          can :create, UserBlock if scope?(token, :write_blocks)
          if user&.terms_agreed? && scope?(token, :write_api)
            can :redact, OldNode
            can :redact, OldWay
            can :redact, OldRelation
          end
        end
      end
    end
  end

  private

  def scope?(token, scope)
    token&.includes_scope?(scope)
  end
end

module Users
  class ChangesetCommentsController < CommentsController
    def index
      @title = t ".title", :user => @user.display_name

      comments = ChangesetComment.joins(:changeset)
      comments = comments.where(:author => @user).or(comments.where(:changeset => { :user => @user }))
      comments = comments.visible unless current_user&.moderator?

      @params = params.permit(:display_name, :before, :after)

      selected_comments = if params[:before]
                            comments.where("changeset_comments.id < ?", params[:before]).order(:id => :desc) # rubocop:disable Rails/WhereRange
                          elsif params[:after]
                            comments.where("changeset_comments.id > ?", params[:after]).order(:id => :asc)
                          else
                            comments.order(:id => :desc)
                          end
      selected_comments = selected_comments.limit(20)

      selected_comment_and_changeset_ids = selected_comments.pluck(:id, :changeset_id)
      selected_comment_and_changeset_ids = selected_comment_and_changeset_ids.sort.reverse

      if selected_comment_and_changeset_ids.count.positive?
        newer_comment_id = selected_comment_and_changeset_ids.first[0]
        older_comment_id = selected_comment_and_changeset_ids.last[0]
        @newer_comments_id = newer_comment_id if comments.exists?(["changeset_comments.id > ?", newer_comment_id])
        @older_comments_id = older_comment_id if comments.exists?(["changeset_comments.id < ?", older_comment_id])
      end

      @selected_comment_ids = Set.new selected_comment_and_changeset_ids.map(&:first)
      selected_changeset_ids = Set.new selected_comment_and_changeset_ids.map(&:last)

      @comments = ChangesetComment.where(:changeset => selected_changeset_ids)
      @comments = @comments.visible unless current_user&.moderator?
      @comments = @comments.order(:id => :desc)
    end
  end
end

class ChangesetTagsController < ApplicationController
  layout "site"

  before_action :authorize_web
  before_action :set_locale
  before_action :check_database_readable

  authorize_resource

  def show
    @changeset = Changeset.find(params[:changeset_id])
  rescue ActiveRecord::RecordNotFound
    render :action => "changeset_not_found", :status => :not_found
  end

  def destroy
    begin
      @changeset = Changeset.find(params[:changeset_id])
    rescue ActiveRecord::RecordNotFound
      render :action => "changeset_not_found", :status => :not_found
      return
    end
    begin
      @key = Base64.urlsafe_decode64(params[:base64_key].to_s)
      @changeset_tag = ChangesetTag.find([params[:changeset_id], @key])
    rescue ActiveRecord::RecordNotFound
      render :action => "tag_not_found", :status => :not_found
      return
    end

    @changeset_tag.delete
    redirect_to changeset_tags_path(@changeset)
  end
end

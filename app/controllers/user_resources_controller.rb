# base class for controllers with user name or id in their path

class UserResourcesController < ApplicationController
  private

  ##
  # ensure that there is a "user" instance variable
  def lookup_user
    @user = User.active.find_by!(:display_name => params[:display_name])
  rescue ActiveRecord::RecordNotFound
    render_unknown_user params[:display_name]
  end

  ##
  # render a "no such user" page
  def render_unknown_user(name)
    @title = t "users.no_such_user.title"
    @not_found_user = name

    respond_to do |format|
      format.html { render :template => "users/no_such_user", :status => :not_found }
      format.all { head :not_found }
    end
  end
end

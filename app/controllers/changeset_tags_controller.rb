class ChangesetTagsController < ApplicationController
  layout "site"

  before_action :authorize_web
  before_action :set_locale
  before_action :check_database_readable

  authorize_resource

  def show; end
end

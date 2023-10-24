module Account
  class DeletionsController < ApplicationController
    layout "site"

    before_action :authorize_web
    before_action :set_locale

    authorize_resource :class => false

    def show
      @allowed_at = current_user.deletion_allowed_at
    end
  end
end

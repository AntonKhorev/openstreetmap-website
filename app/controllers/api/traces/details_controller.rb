module Api
  module Traces
    class DetailsController < ApiController
      before_action :set_locale
      before_action :authorize

      authorize_resource :trace

      def show
        @trace = Trace.visible.find(params[:trace_id])

        head :forbidden unless @trace.public? || @trace.user == current_user
      end
    end
  end
end

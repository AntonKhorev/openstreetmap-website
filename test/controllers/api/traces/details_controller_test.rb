require "test_helper"

module Api
  module Traces
    class DetailsControllerTest < ActionDispatch::IntegrationTest
      ##
      # test all routes which lead to this controller
      def test_routes
        assert_routing(
          { :path => "/api/0.6/gpx/1/details", :method => :get },
          { :controller => "api/traces/details", :action => "show", :trace_id => "1" }
        )
      end

      # Check getting a specific trace through the api
      def test_show
        public_trace_file = create(:trace, :visibility => "public")

        # First with no auth
        get api_trace_details_path(public_trace_file)
        assert_response :unauthorized

        # Now with some other user, which should work since the trace is public
        auth_header = bearer_authorization_header
        get api_trace_details_path(public_trace_file), :headers => auth_header
        assert_response :success

        # And finally we should be able to do it with the owner of the trace
        auth_header = bearer_authorization_header public_trace_file.user
        get api_trace_details_path(public_trace_file), :headers => auth_header
        assert_response :success
        assert_select "gpx_file[id='#{public_trace_file.id}'][uid='#{public_trace_file.user.id}']", 1
      end

      # Check an anonymous trace can't be specifically fetched by another user
      def test_show_anon
        anon_trace_file = create(:trace, :visibility => "private")

        # First with no auth
        get api_trace_details_path(anon_trace_file)
        assert_response :unauthorized

        # Now try with another user, which shouldn't work since the trace is anon
        auth_header = bearer_authorization_header
        get api_trace_details_path(anon_trace_file), :headers => auth_header
        assert_response :forbidden

        # And finally we should be able to get the trace details with the trace owner
        auth_header = bearer_authorization_header anon_trace_file.user
        get api_trace_details_path(anon_trace_file), :headers => auth_header
        assert_response :success
      end

      # Check the api details for a trace that doesn't exist
      def test_show_not_found
        deleted_trace_file = create(:trace, :deleted)

        # Try first with no auth, as it should require it
        get api_trace_details_path(:trace_id => 0)
        assert_response :unauthorized

        # Login, and try again
        auth_header = bearer_authorization_header deleted_trace_file.user
        get api_trace_details_path(:trace_id => 0), :headers => auth_header
        assert_response :not_found

        # Now try a trace which did exist but has been deleted
        auth_header = bearer_authorization_header deleted_trace_file.user
        get api_trace_details_path(deleted_trace_file), :headers => auth_header
        assert_response :not_found
      end
    end
  end
end

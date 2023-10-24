require "test_helper"

class DeletionsControllerTest < ActionDispatch::IntegrationTest
  def test_no_changesets
    with_user_account_deletion_delay(10000) do
      user = create(:user)
      session_for(user)

      get account_deletion_path
      assert_response :success
      assert_select ".btn", "Delete Account" do
        assert_select ">@disabled", 0
      end
    end
  end

  def test_no_delay
    with_user_account_deletion_delay(0) do
      user = create(:user)
      create(:changeset, :user => user)
      session_for(user)

      get account_deletion_path
      assert_response :success
      assert_select ".btn", "Delete Account" do
        assert_select ">@disabled", 0
      end
    end
  end

  def test_past_delay
    with_user_account_deletion_delay(10) do
      user = create(:user)
      create(:changeset, :user => user, :created_at => Time.now.utc - 10.hours)
      session_for(user)

      get account_deletion_path
      assert_response :success
      assert_select ".btn", "Delete Account" do
        assert_select ">@disabled", 0
      end
    end
  end

  def test_delay
    with_user_account_deletion_delay(10) do
      user = create(:user)
      create(:changeset, :user => user, :created_at => Time.now.utc - 9.hours)
      session_for(user)

      get account_deletion_path
      assert_response :success
      assert_select ".btn", "Delete Account" do
        assert_select ">@disabled", 1
      end
      assert_select "time", 1 do
        assert_select ">@datetime", (Time.now.utc + 1.hour).xmlschema
      end
    end
  end
end

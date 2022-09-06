require "application_system_test_case"

class HistoryTest < ApplicationSystemTestCase
  test "restore state of user's changesets list" do
    page_size = 20
    user = create(:user)
    create(:changeset, :user => user, :num_changes => 1) do |changeset|
      create(:changeset_tag, :changeset => changeset, :k => "comment", :v => "first-changeset-in-history")
    end
    page_size.times do
      create(:changeset, :user => user, :num_changes => 1) do |changeset|
        create(:changeset_tag, :changeset => changeset, :k => "comment", :v => "next-changeset")
      end
    end

    visit "#{user_path(user)}/history"
    original_changesets = find "div.changesets"
    original_changesets.assert_no_text "first-changeset-in-history"
    load_more = original_changesets.find ".changeset_more a.btn"
    load_more.click
    original_changesets.assert_text "first-changeset-in-history"

    visit user_path(user)
    go_back
    reloaded_changesets = find "div.changesets"
    reloaded_changesets.assert_text "first-changeset-in-history"
  end
end

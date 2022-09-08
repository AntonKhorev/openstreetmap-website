require "application_system_test_case"

class HistoryTest < ApplicationSystemTestCase
  PAGE_SIZE = 20

  test "restore state of user's changesets list" do
    user = create(:user)
    create_visible_changeset(user, "first-changeset-in-history")
    PAGE_SIZE.times do
      create_visible_changeset(user, "next-changeset")
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

  test "have only one list element on user's changesets page" do
    user = create(:user)
    create_visible_changeset(user, "first-changeset-in-history")
    create_visible_changeset(user, "bottom-changeset-in-batch-2")
    (PAGE_SIZE - 1).times do
      create_visible_changeset(user, "next-changeset")
    end
    create_visible_changeset(user, "bottom-changeset-in-batch-1")
    (PAGE_SIZE - 1).times do
      create_visible_changeset(user, "next-changeset")
    end

    visit "#{user_path(user)}/history"
    changesets = find "div.changesets"
    changesets.assert_text "bottom-changeset-in-batch-1"
    changesets.assert_no_text "bottom-changeset-in-batch-2"
    changesets.assert_no_text "first-changeset-in-history"
    changesets.assert_selector "ol", :count => 1
    changesets.assert_selector "li", :count => PAGE_SIZE

    changesets.find(".changeset_more a.btn").click
    changesets.assert_text "bottom-changeset-in-batch-1"
    changesets.assert_text "bottom-changeset-in-batch-2"
    changesets.assert_no_text "first-changeset-in-history"
    changesets.assert_selector "ol", :count => 1
    changesets.assert_selector "li", :count => 2 * PAGE_SIZE

    changesets.find(".changeset_more a.btn").click
    changesets.assert_text "bottom-changeset-in-batch-1"
    changesets.assert_text "bottom-changeset-in-batch-2"
    changesets.assert_text "first-changeset-in-history"
    changesets.assert_selector "ol", :count => 1
    changesets.assert_selector "li", :count => (2 * PAGE_SIZE) + 1
  end

  def create_visible_changeset(user, comment)
    create(:changeset, :user => user, :num_changes => 1) do |changeset|
      create(:changeset_tag, :changeset => changeset, :k => "comment", :v => comment)
    end
  end
end

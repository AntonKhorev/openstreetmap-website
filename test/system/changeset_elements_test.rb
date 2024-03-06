require "application_system_test_case"

class ChangesetElementsTest < ApplicationSystemTestCase
  test "can navigate between element subpages without losing comment input" do
    element_page_size = 20
    changeset = create(:changeset, :closed)
    ways = create_list(:way, element_page_size + 1, :with_history, :changeset => changeset)
    nodes = create_list(:node, element_page_size + 1, :with_history, :changeset => changeset)

    sign_in_as(create(:user))
    visit changeset_path(changeset)

    within_sidebar do
      ways[0...element_page_size].each do |way|
        assert_link :href => way_path(way)
      end
      assert_no_link :href => way_path(ways[element_page_size])
      assert_link "Ways (21-21 of 21)"

      nodes[0...element_page_size].each do |node|
        assert_link :href => node_path(node)
      end
      assert_no_link :href => node_path(nodes[element_page_size])
      assert_link "Nodes (21-21 of 21)"
    end
  end
end

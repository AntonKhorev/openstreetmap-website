require "test_helper"

class DiscussionsHelperTest < ActionView::TestCase
  def test_empty_discussion
    discussions = discussions_with_selected_comments([], [], :discussion_id)
    assert_empty discussions
  end

  def test_discussion_with_selected_comment
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" }]
    selected_comment_ids = [42]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :selected => true }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_2_selected_comments
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" },
                        { :id => 41, :discussion_id => 12, :text => "test 41" }]
    selected_comment_ids = [42, 41]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :selected => true },
                                    { :comment => { :id => 41, :discussion_id => 12, :text => "test 41" }, :selected => true }] }
    assert_equal expected_discussions, discussions
  end

  def test_2_discussions_with_2_selected_comments
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" },
                        { :id => 41, :discussion_id => 11, :text => "test 41" }]
    selected_comment_ids = [42, 41]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12, 11], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :selected => true }],
                             11 => [{ :comment => { :id => 41, :discussion_id => 11, :text => "test 41" }, :selected => true }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_selected_and_unselected_comments
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" },
                        { :id => 41, :discussion_id => 12, :text => "test 41" }]
    selected_comment_ids = [42]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :selected => true },
                                    { :comment => { :id => 41, :discussion_id => 12, :text => "test 41" }, :selected => false }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_short_context_before_selected_comment
    context_comments = [{ :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 153, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :selected => true }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_long_context_before_selected_comment
    context_comments = [{ :id => 154, :discussion_id => 23 },
                        { :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{},
                                    { :comment => { :id => 153, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :selected => true }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_short_context_after_selected_comment
    context_comments = [{ :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [153]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 153, :discussion_id => 23 }, :selected => true },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :selected => false }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_long_context_after_selected_comment
    context_comments = [{ :id => 154, :discussion_id => 23 },
                        { :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [154]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 154, :discussion_id => 23 }, :selected => true },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :selected => false },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :selected => false },
                                    {}] }
    assert_equal expected_discussions, discussions
  end
end

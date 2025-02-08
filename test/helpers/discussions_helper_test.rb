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
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_2_selected_comments
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" },
                        { :id => 41, :discussion_id => 12, :text => "test 41" }]
    selected_comment_ids = [42, 41]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :distance => 0 },
                                    { :comment => { :id => 41, :discussion_id => 12, :text => "test 41" }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_2_discussions_with_2_selected_comments
    context_comments = [{ :id => 42, :discussion_id => 12, :text => "test 42" },
                        { :id => 41, :discussion_id => 11, :text => "test 41" }]
    selected_comment_ids = [42, 41]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12, 11], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12, :text => "test 42" }, :distance => 0 }],
                             11 => [{ :comment => { :id => 41, :discussion_id => 11, :text => "test 41" }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_shortest_context_before_selected_comment
    context_comments = [{ :id => 42, :discussion_id => 12 },
                        { :id => 41, :discussion_id => 12 }]
    selected_comment_ids = [41]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12 }, :distance => 1 },
                                    { :comment => { :id => 41, :discussion_id => 12 }, :distance => 0 }] }
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
    expected_discussions = { 23 => [{ :comment => { :id => 153, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
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
    expected_discussions = { 23 => [{ :distance => 4 },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_shortest_context_after_selected_comment
    context_comments = [{ :id => 42, :discussion_id => 12 },
                        { :id => 41, :discussion_id => 12 }]
    selected_comment_ids = [42]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [12], discussions.keys
    expected_discussions = { 12 => [{ :comment => { :id => 42, :discussion_id => 12 }, :distance => 0 },
                                    { :comment => { :id => 41, :discussion_id => 12 }, :distance => 1 }] }
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
    expected_discussions = { 23 => [{ :comment => { :id => 153, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 3 }] }
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
    expected_discussions = { 23 => [{ :comment => { :id => 154, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 3 },
                                    { :distance => 4 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_context_comment_between_selected_comments
    context_comments = [{ :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [152, 150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 152, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_2_context_comments_between_selected_comments
    context_comments = [{ :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [153, 150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 153, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_5_context_comments_between_selected_comments
    context_comments = [{ :id => 156, :discussion_id => 23 },
                        { :id => 155, :discussion_id => 23 },
                        { :id => 154, :discussion_id => 23 },
                        { :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [156, 150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 156, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 155, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 154, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_6_context_comments_between_selected_comments
    context_comments = [{ :id => 157, :discussion_id => 23 },
                        { :id => 156, :discussion_id => 23 },
                        { :id => 155, :discussion_id => 23 },
                        { :id => 154, :discussion_id => 23 },
                        { :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [157, 150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 157, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 156, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 155, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 154, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end

  def test_discussion_with_7_context_comments_between_selected_comments
    context_comments = [{ :id => 158, :discussion_id => 23 },
                        { :id => 157, :discussion_id => 23 },
                        { :id => 156, :discussion_id => 23 },
                        { :id => 155, :discussion_id => 23 },
                        { :id => 154, :discussion_id => 23 },
                        { :id => 153, :discussion_id => 23 },
                        { :id => 152, :discussion_id => 23 },
                        { :id => 151, :discussion_id => 23 },
                        { :id => 150, :discussion_id => 23 }]
    selected_comment_ids = [158, 150]

    discussions = discussions_with_selected_comments(context_comments, selected_comment_ids, :discussion_id)

    assert_equal [23], discussions.keys
    expected_discussions = { 23 => [{ :comment => { :id => 158, :discussion_id => 23 }, :distance => 0 },
                                    { :comment => { :id => 157, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 156, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 155, :discussion_id => 23 }, :distance => 3 },
                                    { :distance => 4 },
                                    { :comment => { :id => 153, :discussion_id => 23 }, :distance => 3 },
                                    { :comment => { :id => 152, :discussion_id => 23 }, :distance => 2 },
                                    { :comment => { :id => 151, :discussion_id => 23 }, :distance => 1 },
                                    { :comment => { :id => 150, :discussion_id => 23 }, :distance => 0 }] }
    assert_equal expected_discussions, discussions
  end
end

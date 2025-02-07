module DiscussionsHelper
  def discussions_with_selected_comments(context_comments, selected_comment_ids, discussion_key)
    context_comments.each_with_object({}) do |comment, discussions|
      discussion_id = comment[discussion_key]
      discussions[discussion_id] ||= []
      discussions[discussion_id] << { :comment => comment, :selected => selected_comment_ids.include?(comment[:id]) }
    end
  end
end

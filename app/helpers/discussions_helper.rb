module DiscussionsHelper
  CONTEXT_SIZE = 3

  def discussions_with_selected_comments(context_comments, selected_comment_ids, discussion_key)
    all_comments_collected_for_discussions = context_comments.each_with_object({}) do |comment, all_comments|
      discussion_id = comment[discussion_key]
      all_comments[discussion_id] ||= []
      all_comments[discussion_id] << comment
    end

    all_comments_collected_for_discussions.transform_values do |all_comments|
      discussion_items = []
      skipped_before = false
      can_keep_after = 0
      context_buffer = []

      all_comments.each do |comment|
        if selected_comment_ids.include?(comment[:id])
          if skipped_before
            discussion_items << {}
            skipped_before = false
          end
          discussion_items.concat(context_buffer)
          context_buffer = []
          discussion_items << { :comment => comment, :selected => true }
          can_keep_after = CONTEXT_SIZE
        elsif can_keep_after.positive?
          discussion_items << { :comment => comment, :selected => false }
          can_keep_after -= 1
        else
          context_buffer << { :comment => comment, :selected => false }
          if context_buffer.size > CONTEXT_SIZE
            skipped_before = true
            context_buffer.shift
          end
        end
      end

      discussion_items << {} if context_buffer.size.positive?

      discussion_items
    end
  end
end

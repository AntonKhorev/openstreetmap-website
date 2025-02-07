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
      context_buffer = []

      all_comments.each do |comment|
        if selected_comment_ids.include?(comment[:id])
          discussion_items.concat flush_buffer(context_buffer, !discussion_items.empty?, true)
          discussion_items << { :comment => comment }
        else
          context_buffer << comment
        end
      end

      discussion_items.concat flush_buffer(context_buffer, !discussion_items.empty?, false)
    end
  end

  private

  def flush_buffer(buffer, with_start, with_end)
    skipped = false
    result = []

    buffer.each_with_index do |comment, i|
      start_distance = with_start ? i + 1 : Float::INFINITY
      end_distance = with_end ? buffer.size - i : Float::INFINITY
      distance = [start_distance, end_distance].min
      if distance > CONTEXT_SIZE
        result << {} unless skipped
        skipped = true
      else
        result << { :comment => comment, :class => opacity_for_distance(distance) }
      end
    end
    buffer.clear

    result
  end

  def opacity_for_distance(n)
    case n
    in 1
      "opacity-75"
    in 2
      "opacity-50"
    else
      "opacity-25"
    end
  end
end

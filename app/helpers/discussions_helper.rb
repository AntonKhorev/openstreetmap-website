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
          discussion_items << { :comment => comment, :distance => 0 }
        else
          context_buffer << comment
        end
      end

      discussion_items.concat flush_buffer(context_buffer, !discussion_items.empty?, false)
    end
  end

  def discussion_item_row_css_class(item)
    if item[:comment]
      if !item[:comment].visible?
        "table-danger"
      elsif item[:distance].positive?
        "table-secondary"
      end
    else
      "table-secondary"
    end
  end

  def discussion_item_opacity_css_class(item)
    case item[:distance]
    when 0
      nil
    when 1
      "opacity-75"
    when 2
      "opacity-50"
    else
      "opacity-25"
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
        result << { :distance => distance } unless skipped
        skipped = true
      else
        result << { :comment => comment, :distance => distance }
      end
    end
    buffer.clear

    result
  end
end

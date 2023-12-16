module SvgHelper
  def svg_image_tag(width, height, **rect_attrs)
    stroke_side_x = rect_attrs["stroke-direction"] == "horizontal" ? -1 : 1
    stroke_side_y = rect_attrs["stroke-direction"] == "vertical" ? -1 : 1
    rect_attrs = rect_attrs.except("stroke-direction")
    stroke_width = rect_attrs["stroke"] ? 1 : 0
    inset_x = 0.5 * stroke_side_x * stroke_width if stroke_width.positive?
    inset_y = 0.5 * stroke_side_y * stroke_width if stroke_width.positive?
    rect_geometry_attrs = {
      :x => inset_x,
      :y => inset_y,
      :width => width - (stroke_side_x * stroke_width),
      :height => height - (stroke_side_y * stroke_width)
    }
    rect = tag.rect(**rect_geometry_attrs, **rect_attrs)
    svg = tag.svg rect, :xmlns => "http://www.w3.org/2000/svg", :width => width, :height => height
    image_tag "data:image/svg+xml,#{u(svg)}"
  end
end

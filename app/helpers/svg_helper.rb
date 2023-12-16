module SvgHelper
  def svg_image_tag(width, height, **rect_attrs)
    stroke_width = rect_attrs[:stroke] ? 1 : 0
    inset = 0.5 * stroke_width if stroke_width.positive?
    rect_geometry_attrs = {
      :x => inset,
      :y => inset,
      :width => width - stroke_width,
      :height => height - stroke_width
    }
    rect = tag.rect(**rect_geometry_attrs, **rect_attrs)
    svg = tag.svg rect, :xmlns => "http://www.w3.org/2000/svg", :width => width, :height => height
    image_tag "data:image/svg+xml,#{u(svg)}"
  end
end

module SvgHelper
  def bordered_svg_tag(**options)
    stroke_width = options["stroke"] ? (options["stroke-width"] || 1) : 0
    inset = 0.5 * stroke_width if stroke_width.positive?
    rect_geometry_attrs = {
      :x => inset,
      :y => inset,
      :width => options["width"] - stroke_width,
      :height => options["height"] - stroke_width
    }
    rect_attrs = options.slice("fill", "stroke", "stroke-width", "stroke-dasharray", "stroke-dashoffset")
    rect_attrs["fill"] ||= "none"
    svg_attrs = options.slice("width", "height", "opacity", :class)

    tag.svg(**svg_attrs) do
      tag.rect(**rect_geometry_attrs, **rect_attrs)
    end
  end

  def cased_svg_tag(**options)
    stroke_width = options["stroke"] ? (options["stroke-width"] || 1) : 0
    rect_attrs = options.slice("fill")
    line_attrs = options.slice("stroke", "stroke-width", "stroke-dasharray", "stroke-dashoffset")
    svg_attrs = options.slice("width", "height", "opacity", :class)

    tag.svg(**svg_attrs) do
      concat tag.rect :width => "100%", :height => "100%", **rect_attrs if options["fill"]
      if stroke_width.positive?
        y_top = 0.5 * stroke_width
        y_bottom = options["height"] - (0.5 * stroke_width)
        concat tag.g(tag.line(:x2 => "100%", :y1 => y_top, :y2 => y_top) +
                     tag.line(:x2 => "100%", :y1 => y_bottom, :y2 => y_bottom),
                     **line_attrs)
      end
    end
  end

  def striked_svg_tag(**options)
    stroke_width = options["stroke"] ? (options["stroke-width"] || 1) : 0
    rect_attrs = options.slice("fill")
    line_attrs = options.slice("stroke", "stroke-width", "stroke-dasharray", "stroke-dashoffset")
    svg_attrs = options.slice("width", "height", "opacity", :class)

    tag.svg(**svg_attrs) do
      concat tag.rect :width => "100%", :height => "100%", **rect_attrs if options["fill"]
      concat tag.line :x2 => "100%", :y1 => "50%", :y2 => "50%", **line_attrs if stroke_width.positive?
    end
  end
end

module ApplicationHelper
  def page_title(title)
    @title = title
    content_tag(:h1, h(title))
  end

  def gchart_debug(data, options={})
    content_tag(:div, h(gchart(data, options)), :class => "debug")
  end

  def gchart(data, options={})
    params = gchart_params(data, options)
    image_tag(
      "http://chart.apis.google.com/chart?#{params.to_query}",
      :size => options[:size]
    )
  end

  def gchart_debug(data, options={})
    params = gchart_params(data, options)
    content_tag(:pre, "http://chart.apis.google.com/chart?\n" + params.map {|key, value| "\t#{h(key)}=#{h(value)}&"}.join("\n")[0..-2])
  end

  def gchart_params(data, options={})
    options.reverse_merge!(:encoding => :simple, :size => "200x80")
    returning(Hash.new) do |params|
      params[:cht] = case options[:type]
                     when :pie;     "p"
                     when :pie3d;   "p3"
                     when :line;    "lc"
                     else;          "lc"
                     end
      gchart_legend(params, options)
      params[:chs] = options[:size]
      params[:chd] = send("gchart_#{options[:encoding]}_encoding", data, options[:max_value])
    end
  end

  def gchart_legend(params, options)
    case options[:type]
    when :pie, :pie3d
      params[:chl] = options[:legend].join("|") if options.has_key?(:legend)
    else
      params[:chdl] = options[:legend].join(",") if options.has_key?(:legend)
    end
  end

  SIMPLE_ENCODING = [("A".."Z"), ("a".."z"), ("0".."9")].map(&:to_a).flatten
  SIMPLE_ENCODING_LENGTH = SIMPLE_ENCODING.length.to_f
  def gchart_simple_encoding(data, max_value=data.reject(&:blank?).max)
    returning("s:") do |buf|
      buf << data.map {|value|
        value.blank? ? "_" : gchart_encode(value, max_value, SIMPLE_ENCODING)
      }.join
    end
  end

  def gchart_encode(value, max_value, values)
    index = (values.length * (value / max_value.to_f)).floor
    values[index]
  end
end

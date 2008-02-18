module ApplicationHelper
  def page_title(title)
    @title = title
    content_tag(:h1, h(title))
  end
end

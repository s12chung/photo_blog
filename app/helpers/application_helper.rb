module ApplicationHelper
  def title_default
    "Travel Captions"
  end

  def title_short
    "TC"
  end

  def set_title(title=title_default)
    if title
      content_for :title, "#{title}"
    end
    title
  end
  def title
    content_for?(:title) ? content_for(:title) : raise("No content for title HTML tag")
  end
end

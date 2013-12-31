module ApplicationHelper
  def title_default
    "4 Weeks in Kansai"
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

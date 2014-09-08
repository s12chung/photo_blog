module ApplicationHelper
  def site_name
    "Travel Captions"
  end
  def title_default
    "#{site_name} - #{description}"
  end
  def description
    "Capturing travel with individual photos and their story."
  end
  def logo_url
    asset_url("logo.png").http_url
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

  def asset_url(asset)
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
end

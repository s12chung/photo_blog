module PostPresenter
  def coords
    coords = {}
    self.class::CROP_TYPES.each do |crop_type|
      coords[crop_type] = self.send("crop_#{crop_type}").to_f
    end
    coords
  end

  def clean_markdown
    markdown.sub(self.class::SUMMARY_CUTOFF, "")
  end
  def markdown_html
    html
  end
  def summary_html
    html false
  end

  def to_photoswipe
    {
        title: title,
        photo: photo.to_crop.url,
        caption: render("summary_content", post: self),
        path: post_path(self)
    }
  end

  protected
  def html(full=true)
    partition = markdown.partition self.class::SUMMARY_CUTOFF
    content = partition.first

    if !full && partition[1] == "[\u2026]"
      content.chomp!(".")
      content += "\u2026"
    end
    if partition.last.first == "\r"
      content = content_tag :p, content, class: "huge"
    end

    if full
      content += partition.last
    end

    self.class.process_markdown content
  end

  module ClassMethods
    def process_markdown(markdown)
      markdown_options = %w/autolink no_intra_emphasis/
      renderer_options = %w/hard_wrap/
      renderer = Redcarpet::Markdown.new(
          Redcarpet::Render::HTML.new(Hash[renderer_options.map {|o| [o.to_sym, true]}]),
          Hash[markdown_options.map {|o| [o.to_sym, true]}])
      renderer.render(markdown).html_safe
    end
  end
end
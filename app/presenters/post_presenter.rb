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
    self.class.process_markdown clean_markdown
  end
  def summary_html
    self.class.process_markdown markdown.split(self.class::SUMMARY_CUTOFF).first + "\u2026"
  end

  def to_photoswipe
    {
        title: title,
        photo: photo_url(:to_crop),
        caption: render("summary_content", post: self),
        path: post_path(self)
    }
  end

  protected
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
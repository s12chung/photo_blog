module PostPresenter
  def coords
    coords = {}
    self.class::CROP_TYPES.each do |crop_type|
      coords[crop_type] = self.send("crop_#{crop_type}").to_f
    end
    coords
  end

  def markdown_html
    partition = markdown.partition(/\r\n/)
    first_paragraph = partition.first
    content = if first_paragraph.scan(".?!").count <= 2
                content_tag(:p, first_paragraph, class: "huge") + partition.last
              else
                markdown
              end
    self.class.process_markdown content
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
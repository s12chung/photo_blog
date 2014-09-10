module PostPresenter
  FOOTNOTE_REGEX = /\[\|\]/
  BULLET_REGEX = /[-*]\s{0,3}/

  def localized_date
    l date, locale: locale
  end
  def coords
    coords = {}
    self.class::CROP_TYPES.each do |crop_type|
      coords[crop_type] = self.send("crop_#{crop_type}").to_f
    end
    coords
  end

  def to_facebook
    image = photo.retina
    {
        og: {
            type: :article,
            description: description,
            image: {
                url: image.url.http_url,
                secure_url: image.url,
                type: "image/jpeg",
                width: image.dimensions['width'],
                height: image.dimensions['height']
            }
        },
        article: {
            published_time: published_at.try(:iso8601),
            modified_time: updated_at.iso8601,
            author: root_markdown_url(:about),
            tag: tags_array
        }
    }
  end
  def to_twitter
    image_url = photo.retina.url.http_url
    data = if has_content?
             {
                 card: :summary_large_image,
                 image: {
                     src: image_url
                 }
             }
           else
             {
                 card: :photo,
                 image: image_url
             }
           end
    {
        twitter: data.merge(
            description: description
        )
    }
  end

  def tags_array
    if tags
      tags.split(",").map {|tag| tag.strip }
    end
  end

  def read_story
    if has_content?
      content_tag :div do
        link_to "Read Story", "#main_content",
                data: { behavior: user_agent.mobile? ? "show_popup" : "scroll_to", offset: 1 }, class: "read_story"
      end
    end
  end
  def snippet
    if !has_content?
      content_tag :div, class: "html" do
        self.class.process_markdown(markdown, HasMarkdown::PlainTextRenderer) || description
      end
    end
  end
  def markdown_html
    content_array = []
    markdown.split(FOOTNOTE_REGEX).each_with_index do |split, index|
      if index > 0
        content_array << link_to(content_tag(:sup, index), "#footnote_#{index}", id: "footnote_reference_#{index}",
                                 title: self.class.process_markdown(footnotes[index - 1], HasMarkdown::PlainTextRenderer),
                                 data: { behavior: "scroll_to tipsy", offset: -5, })
      end
      content_array << split
    end
    self.class.process_markdown content_array.join, HasMarkdown::PostRenderer
  end
  def footnotes
    @footnotes ||= if footnote_text.empty?
                     []
                   else
                     split = footnote_text.split(/\r\n#{BULLET_REGEX}/)
                     split.first.sub!(BULLET_REGEX, "")
                     split
                   end
  end
  def footnote_points
    footnotes.each_with_index.map do |footnote, index|
      index = index + 1
      content_tag :li, id: "footnote_#{index}" do
        self.class.process_markdown(footnote, HasMarkdown::FootnoteRenderer) +
            link_to(raw("&#8617;"), "#footnote_reference_#{index}", data: { behavior: "scroll_to", offset: -5 })
      end
    end.join.html_safe
  end
  def comment_box
    link_to image_tag("comment.svg", class: "comment_box"), "#comments",
            data: { behavior: user_agent.mobile? ? "show_comment" : "scroll_to" }
  end

  module ClassMethods
    def direction(change)
      change == -1 ? :left : :right
    end
  end
end
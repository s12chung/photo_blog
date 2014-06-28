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
    image = MiniMagick::Image.open(photo.url)
    {
        og: {
            type: :article,
            description: has_content? ? description : markdown,
            image: {
                url: photo.url,
                secure_url: photo.url,
                type: "image/jpeg",
                width: image['width'],
                height: image['height']
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
  def tags_array
    if tags
      tags.split(",").map {|tag| tag.strip }
    end
  end

  def read_story
    if has_content?
      content_tag :div do
        link_to "Read Story", "#main_content",
                data: { behavior: user_agent.mobile? ? "show_popup" : "scroll_to" }, class: "read_story"
      end
    end
  end
  def snippet
    unless has_content?
      content_tag :div, class: "html" do
        markdown_html
      end
    end
  end
  def markdown_html
    partition = markdown.partition(/\r\n/)
    first_paragraph = partition.first
    content = if has_content? && first_paragraph.scan(".?!").count <= 2
                content_tag(:p, first_paragraph, class: "huge") + partition.last
              else
                markdown
              end

    content_array = []
    content.split(FOOTNOTE_REGEX).each_with_index do |split, index|
      if index > 0
        content_array << link_to(content_tag(:sup, index), "#footnote_#{index}", id: "footnote_reference_#{index}",
                                 title: footnotes[index - 1],
                                 data: { behavior: "scroll_to tipsy", offset: -5, })
      end
      content_array << split
    end
    self.class.process_markdown content_array.join("")
  end
  def footnotes
    @footnotes ||= if footnote_text.empty?
                     []
                   else
                     split = footnote_text.split(/\r\n#{BULLET_REGEX}/)
                     split.first.sub!(BULLET_REGEX, "")
                     split
                   end

    @footnotes.each_with_index.map do |footnote, index|
      index = index + 1
      content_tag :li, id: "footnote_#{index}" do
        footnote.html_safe + link_to(raw("&#8617;"), "#footnote_reference_#{index}", data: { behavior: "scroll_to", offset: -5 })
      end
    end.join.html_safe
  end
  def comment_box
    link_to image_tag("comment.svg", class: "comment_box"), "#comments",
            data: { behavior: user_agent.mobile? ? "show_comment" : "scroll_to" }
  end
end
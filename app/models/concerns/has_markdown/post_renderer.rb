module HasMarkdown
  class PostRenderer < Redcarpet::Render::SmartyHTML
    def initialize(options={})
      super options
      @first = true
    end

    def block_quote(quote)
      quote = Nokogiri::HTML(quote).at_xpath("html/body")
      paragraphs = quote.xpath("p")
      paragraph = paragraphs.first

      if paragraphs.size == 1 && self.class.short?(paragraph.inner_html)
        paragraph[:class] = "huge"
      else
        paragraph.remove_attribute "class"
      end
      "<blockquote>#{quote.inner_html}</blockquote>"
    end

    def paragraph(text)
      text = text.gsub(/\n/, "<br>")
      if text.index(Post::CITE_REGEX) == 0
        "<cite>#{text}</cite>"
      else
        if @first
          @first = false
          if self.class.short? text
            tag = "<p class=\"huge\">#{text}</p>"
          end
        end
        tag || "<p>#{text}</p>"
      end
    end

    class << self
      def short?(text)
        text.scan(/[.?!\u2026]/).count < 2
      end
    end
  end
end
module HasMarkdown
  class PostRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def initialize(options={})
      super options
      @footnote_index = 0
      @first = true
    end

    def block_quote(quote)
      if self.class.short? quote
        "<blockquote class=\"huge\">#{quote}</blockquote>"
      else
        "<blockquote>#{quote}</blockquote>"
      end
    end

    def paragraph(text)
      if text.index(/---|\u2014/) == 0
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
module HasMarkdown
  class PostRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def initialize(options={})
      super options
      @footnote_index = 0
      @first = true
    end

    def paragraph(text)
      if text.index(/---|\u2014/) == 0
        "<cite>#{text}</cite>"
      else
        if @first
          @first = false
          if text.scan(/[.?!\u2026]/).count < 2
            tag = "<p class=\"huge\">#{text}</p>"
          end
        end
        tag || "<p>#{text}</p>"
      end
    end
  end
end
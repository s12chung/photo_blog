module HasMarkdown
  class FootnoteRenderer < Redcarpet::Render::SmartyHTML
    def paragraph(text)
      text
    end
  end
end
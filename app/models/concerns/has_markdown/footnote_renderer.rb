module HasMarkdown
  class FootnoteRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def paragraph(text)
      text
    end
  end
end
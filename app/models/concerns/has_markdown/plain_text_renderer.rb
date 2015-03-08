module HasMarkdown
  class PlainTextRenderer < Redcarpet::Render::SmartyHTML
    def initialize(options={})
      super options
      @list_count = 0
    end

    # Methods where the first argument is the text content
    [
        # block-level calls
        :block_code, :block_html,

        # span-level calls
        :autolink, :codespan, :double_emphasis,
        :emphasis, :underline, :raw_html,
        :triple_emphasis, :strikethrough,
        :superscript,

        # low level rendering
        :entity, :normal_text
    ].each do |method|
      define_method method do |*args|
        args.first
      end
    end

    def list(text, list_type)
      @list_count = 0
      "#{text}\n"
    end

    def list_item(text, list_type)
      "#{list_type == "li" ? "-" : "#{@list_count += 1}."} #{text}"
    end

    def block_quote(text)
      quote, dash, source = text.partition(Post::CITE_REGEX)
      "\"#{quote.strip}\"#{dash.blank? ? "" : "\n#{dash + source}"}\n\n"
    end

    def paragraph(text)
      if text.index(Post::CITE_REGEX) == 0
        text
      else
        header text
      end
    end

    def header(text)
      "#{text}\n\n"
    end

    # Other methods where the text content is in another argument
    def link(link, title, content)
      content
    end

    def postprocess(full_document)
      full_document.strip!
      full_document
    end
  end
end
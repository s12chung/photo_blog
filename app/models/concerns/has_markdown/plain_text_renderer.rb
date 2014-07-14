module HasMarkdown
  class PlainTextRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    # Methods where the first argument is the text content
    [
        # block-level calls
        :block_code, :block_quote,
        :block_html, :list, :list_item,

        # span-level calls
        :autolink, :codespan, :double_emphasis,
        :emphasis, :underline, :raw_html,
        :triple_emphasis, :strikethrough,
        :superscript,

        # low level rendering
        :entity, :normal_text,

        :paragraph, :header
    ].each do |method|
      define_method method do |*args|
        args.first
      end
    end

    # Other methods where the text content is in another argument
    def link(link, title, content)
      content
    end
  end
end
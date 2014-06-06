module HasMarkdown
  extend ActiveSupport::Concern

  module ClassMethods
    def process_markdown(markdown)
      if markdown
        markdown_options = %w/autolink no_intra_emphasis/
        renderer_options = %w/hard_wrap/
        renderer = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new(Hash[renderer_options.map {|o| [o.to_sym, true]}].merge(
                                            link_attributes: { target: "_blank" }
                                        )),
            Hash[markdown_options.map {|o| [o.to_sym, true]}])
        renderer.render(markdown).html_safe
      end
    end
  end
end
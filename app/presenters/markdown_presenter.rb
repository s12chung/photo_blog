module MarkdownPresenter
  def html
    if markdown
      self.class.process_markdown markdown
    end
  end
end
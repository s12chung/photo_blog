module MarkdownPresenter
  def description
    "#{key.to_s.titleize} Page"
  end

  def to_facebook
    {
        og: {
            type: :profile,
            description: description
        },
        profile: {
            first_name: "Steven",
            last_name: "Chung",
            username: "s12chung",
            gender: "male"
        }
    }
  end

  def to_twitter
    {
        description: description
    }
  end

  def html
    if markdown
      self.class.process_markdown markdown
    end
  end
end
class Markdown
  include Mongoid::Document
  include HasMarkdown

  field :key, type: Symbol
  field :markdown
  include Mongoid::Timestamps

  validates :key, presence: true, uniqueness: true

  PAGES = %w[about]
  class PagesConstraint
    class << self
      def matches?(request)
        PAGES.include? request.params[:key]
      end
    end
  end
end
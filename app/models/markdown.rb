class Markdown
  include Mongoid::Document
  include HasMarkdown

  field :key, type: Symbol
  field :markdown
  include Mongoid::Timestamps

  validates :key, presence: true, uniqueness: true
end
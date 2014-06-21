class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  include HasMarkdown

  field :title, default: "Post Title"
  field :markdown, default: "A post is just the beginning."
  field :footnote_text
  field :place
  field :address
  field :position, type: Point, default: -> { Mongoid::Geospatial::Point.new(0,0) }
  field :date, type: Date, default: -> { Date.today }

  field :published_at, type: DateTime
  field :published, default: false
  field :publish_order, type: Integer

  mount_uploader :photo, PhotoUploader
  CROP_TYPES = %i[x y w h]
  CROP_ATTRIBUTES = CROP_TYPES.map { |coord| "crop_#{coord}".to_sym }
  CROP_ATTRIBUTES.each do |attribute|
    field attribute, type: BigDecimal
  end
  RATIO = Rational(14, 3)

  scope :published, -> { where(published: true).asc(:publish_order) }

  after_update do
    unless (changed & self.class.crop_attributes.map(&:to_s)).empty?
      photo.recreate_versions!(:index)
    end
  end

  def has_content?
    !!markdown.index(/\r\n/)
  end

  def markdown=(markdown)
    super clean_text(markdown)
  end

  def footnote_text=(footnote_text)
    super clean_text(footnote_text)
  end

  def toggle_publish!
    if published
      update_attributes(published_at: nil,
                        publish_order: nil,
                        published: false)
      self.class.published.each_with_index do |post, index|
        post.update_attribute :publish_order, index
      end
    else
      update_attributes(published_at: DateTime.now,
                        publish_order: self.class.published.size,
                        published: true)
    end
  end

  def adjacent(change=1)
    if publish_order
      self.class.where(publish_order: (publish_order + change) % Post.published.size).first
    else
      nil
    end
  end

  protected
  def clean_text(text)
    if text.include? "\""
      raise("You have quotes!")
    end
    text.gsub("...", "\u2026").gsub(" - ", "\u2014")
  end

  class << self
    def crop_types
      CROP_TYPES
    end
    def crop_attributes
      CROP_ATTRIBUTES
    end
  end
end
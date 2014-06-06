class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  field :title, default: "Post Title"
  field :markdown, default: "A post is just the beginning."
  field :footnote_text
  field :location, type: Point, default: -> { Mongoid::Geospatial::Point.new(0,0) }
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

  def publish!
    update_attributes(published_at: DateTime.now,
                      publish_order: self.class.published.size,
                      published: true)
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
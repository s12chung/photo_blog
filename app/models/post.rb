class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, default: "Post Title"
  field :markdown, default: "A post is just the beginning."
  field :date, type: Date, default: -> { Date.today }
  field :draft, type: Boolean, default: false

  mount_uploader :photo, PhotoUploader
  CROP_TYPES = %i[x y w h]
  CROP_ATTRIBUTES = CROP_TYPES.map { |coord| "crop_#{coord}".to_sym }
  CROP_ATTRIBUTES.each do |attribute|
    field attribute, type: BigDecimal
  end
  RATIO = Rational(14, 3)

  after_update do
    unless (changed & self.class.crop_attributes.map(&:to_s)).empty?
      photo.recreate_versions!(:index)
    end
  end

  def has_content?
    !!markdown.index(/\r\n/)
  end

  def markdown=(markdown)
    if markdown.include? "\""
      raise("You have quotes!")
    end
    markdown = markdown.clone
    markdown.gsub!("...", "\u2026")
    markdown.gsub!(" - ", "\u2014")
    super markdown
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
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :text
  field :date, type: Date
  field :draft, type: Boolean

  mount_uploader :photo, PhotoUploader
  COORDS = %w[x y w h]
  CROP_ATTRIBUTES = COORDS.map { |coord| "crop_#{coord}".to_sym }
  CROP_ATTRIBUTES.each do |attribute|
    field attribute, type: BigDecimal
  end

  after_update do
    unless (changed & self.class.crop_attributes.map(&:to_s)).empty?
      photo.recreate_versions!(:index)
    end
  end

  def coords
    coords = {}
    COORDS.each do |coord|
      coords[coord] = self.send("crop_#{coord}").to_f
    end
    coords
  end

  class << self
    def crop_attributes
      CROP_ATTRIBUTES
    end
  end
end
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :text
  field :date, type: ActiveSupport::TimeWithZone
  field :draft, type: Boolean

  mount_uploader :photo, PhotoUploader
  CROP_ATTRIBUTES = %w[x y w h].map { |attribute| "crop_#{attribute}".to_sym }
  attr_accessor *CROP_ATTRIBUTES
  after_update do
    if crop_x
      photo.recreate_versions!(:index)
    end
  end

  class << self
    def crop_attributes
      CROP_ATTRIBUTES
    end
  end
end
class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  mount_uploader :photo, PhotoUploader
end
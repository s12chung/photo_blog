# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :to_crop do
    process :to_crop
  end
  def to_crop
    # 600 x 600 referenced in posts/edit.html.erb
    resize_to_limit(345, 600)
  end

  version :crop_preview do
    process resize_to_limit: [1400, 99999]
  end

  version :index, from_version: :crop_preview do
    process :crop
  end

  def crop
    if model.crop_x.present?
      manipulate! do |img|
        index_image = MiniMagick::Image.open(img.path)
        to_crop_image = MiniMagick::Image.open(model.photo_url(:to_crop))
        ratio_width = index_image['width'] / to_crop_image['width']
        ratio_height = index_image['height'] / to_crop_image['height']

        x = model.crop_x.to_i * ratio_width
        y = model.crop_y.to_i * ratio_height
        w = model.crop_w.to_i * ratio_width
        h = model.crop_h.to_i * ratio_height

        img.crop("#{w}x#{h}+#{x}+#{y}")
        img
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
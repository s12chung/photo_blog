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

  def fog_public
    !!version_name
  end

  def self.platform_sizes
    version :desktop do
      process resize_to_limit: [2880, 2880]
    end
    version :tablet, from_version: :desktop do
      process resize_to_limit: [2048, 2048]
    end
    version :phone, from_version: :tablet do
      process resize_to_limit: [1136, 1136]
    end
  end

  platform_sizes

  version :to_crop, from_version: :phone do
    process resize_to_limit: [Post::TO_CROP_WIDTH, 600]
  end
  version :index, from_version: :desktop do
    process :crop
    version :gray do
      process :convert_to_gray
      platform_sizes
    end

    platform_sizes
  end

  def crop
    manipulate! do |img|
      if model.crop_x
        to_crop_image = MiniMagick::Image.open(model.photo.to_crop.send(model.crop_changed? ? :url : :path))
      else
        model.crop_x = model.crop_y = 0
        model.crop_w = img['width']
        model.crop_h = (model.crop_w/Post::RATIO).to_f
        to_crop_image = img
      end

      crop_values = {}
      model.class::CROP_TYPES.each do |crop_type|
        crop_values[crop_type] = (model.send("crop_#{crop_type}")/to_crop_image['width']) * img['width']
      end

      img.crop("#{crop_values[:w]}x#{crop_values[:h]}+#{crop_values[:x]}+#{crop_values[:y]}")
      img
    end
  end

  def convert_to_gray
    manipulate! do |img|
      background = MiniMagick::Image.open(File.join(*%W[#{Rails.root} app assets images background_negative.png]))
      background.combine_options do |c|
        c.size "#{img['width']}x#{img['height']}"
        c.tile background.path
      end

      img.colorspace("Gray")
      img.brightness_contrast("0x-50")
      img.composite(background) do |c|
        c.compose "ColorDodge"
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

class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # minimagic使用のため
  include CarrierWave::MiniMagick

  # igpostアップロード画像を正方形化
  process resize_to_fill: [1080, 1080, "Center"]

  if Rails.env.development?
    storage :file
  elsif Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(png jpg)
  end

  def filename
    original_filename if original_filename
  end
end

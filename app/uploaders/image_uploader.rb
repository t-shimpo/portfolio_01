class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::MiniMagick
  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url(*)
    #   # For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default.png'].compact.join('_'))
  end

  process resize_to_fit: [700, 700]

  version :thumb do
    process resize_to_fill: [100, 100, 'Center']
  end

  version :thumb200 do
    process resize_to_fill: [200, 200, 'Center']
  end

  version :thumb300 do
    process resize_to_fill: [300, 300, 'Center']
  end

  version :post_thumb400 do
    process resize_to_fit: [400, 400]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  if Rails.env.production?
    def filename
      "#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.#{file.extension}" if original_filename
    end
  end
end

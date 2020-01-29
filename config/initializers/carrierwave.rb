require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage :fog
    config.fog_provider = 'fog/aws'
    config.fog_directory  = 'rails-clogram-bucket'
    config.asset_host = 'https://rails-clogram-bucket.s3.amazonaws.com'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: AKIAZ2FFMZLTQ2MXJU6G,
      aws_secret_access_key: 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,
      region: ap-northeast-1,
      path_style: true
    }
  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
end
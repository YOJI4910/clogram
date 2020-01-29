unless Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAZ2FFMZLTQ2MXJU6G',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory  = 'rails-clogram-bucket'
    config.cache_storage = :fog
  end
end
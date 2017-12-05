require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.store_dir = "#{Rails.root}/tmp/uploads"
  end

  if Rails.env.development?
    config.storage = :file
    config.store_dir = "#{Rails.root}/tmp/uploads"
  end

  if Rails.env.production?
    config.storage = :fog
    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.fog_provider = 'fog/aws'
    config.fog_directory = 'sybookstore'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAJHFZHHFXAN3ECAFQ',
      aws_secret_access_key: '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',
      region: 'eu-central-1',
      endpoint: 'https://s3.eu-central-1.amazonaws.com'
    }
  end
end

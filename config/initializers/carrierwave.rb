CarrierWave.configure do |config|
  if Rails.env.test?
    CarrierWave.configure do |config|
      config.storage = :file
      config.enable_processing = false
      config.store_dir = "#{Rails.root}/tmp/uploads"
    end
  end

  if Rails.env.production? || Rails.env.development?
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAJHFZHHFXAN3ECAFQ',
    aws_secret_access_key: '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',
    region: 'eu-central-1',
    endpoint: 'https://s3.eu-central-1.amazonaws.com'
  }
  config.fog_directory = 'sybookstore'
end

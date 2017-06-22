CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAJHFZHHFXAN3ECAFQ',
    aws_secret_access_key: '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',
    region: 'eu-central-1',
    # host: 'lkjlk',
    endpoint: 'https://s3.eu-central-1.amazonaws.com'
  }
  # config.fog_directory = 'name_of_directory'
  config.fog_directory = 'sybookstore'
  # config.fog_public = true
  # config.for_attributes = { cache_control: 
end

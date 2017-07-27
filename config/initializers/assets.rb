Rails.application.config.assets.version = '1.0'

controllers_names = Dir.glob("#{Rails.root}/app/controllers/*.rb").map do |file|
  name = File.basename(file).split('_')
  name.pop
  name.join('_') << '.js'
end

Rails.application.config.assets.precompile += controllers_names

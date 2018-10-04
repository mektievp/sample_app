if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end

  MiniMagick.configure do |config|
    config.validate_on_create = false
    config.validate_on_write = false
  end
end
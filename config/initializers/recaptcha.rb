Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_PUB']
  config.secret_key = ENV['RECAPTCHA_PK']
end

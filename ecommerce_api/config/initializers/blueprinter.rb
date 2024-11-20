require "oj"

Oj::Rails.mimic_JSON

Blueprinter.configure do |config|
  config.generator = Oj
  config.custom_array_like_classes = [ Mongoid::Criteria ]
end

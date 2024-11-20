class UpdateProductPricesJob
  include Sidekiq::Job
  sidekiq_options queue: "default"

  def perform
    Product.all.each do |product|
      DynamicPricingEngine.new(product).update_price
    end
  end
end

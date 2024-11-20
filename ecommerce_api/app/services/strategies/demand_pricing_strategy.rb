class Strategies::DemandPricingStrategy
  def initialize(product)
    @product = product
  end

  def update_price(current_price)
    demand_multiplier = fetch_demand_multiplier
    current_price * (1 + demand_multiplier)
  end

  private

  def fetch_demand_multiplier
    if @product.demand_high?
      DynamicPricingConfig.demand[:increase]
    else
      DynamicPricingConfig.demand[:decrease]
    end
  end
end

class Strategies::CompetitorPricingStrategy
  def initialize(product)
    @product = product
  end

  def update_price(current_price)
    competitor_price = fetch_competitor_price
    return current_price unless competitor_price

    # Price adjustment based on competitor pricing
    if competitor_price < current_price
      competitor_price * (1 - DynamicPricingConfig.competitor[:decrease])
    elsif competitor_price > current_price
      competitor_price * (1 + DynamicPricingConfig.competitor[:increase])
    else
      current_price
    end
  end

  private

  def fetch_competitor_price
    return unless CompetitorPrice.exists?(product: @product)

    competitor_price = CompetitorPrice.find_by(product: @product)
    competitor_price.price if competitor_price
  end
end

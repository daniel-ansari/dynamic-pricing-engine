class Strategies::InventoryPricingStrategy
  def initialize(product)
    @product = product
  end

  def update_price(current_price)
    inventory_multiplier = fetch_inventory_multiplier
    current_price * (1 + inventory_multiplier)
  end

  private

  def fetch_inventory_multiplier
    if @product.qty < DynamicPricingConfig.inventory[:thresholds][:low]
      DynamicPricingConfig.inventory[:increase]
    elsif @product.qty > DynamicPricingConfig.inventory[:thresholds][:high]
        -1 * DynamicPricingConfig.inventory[:decrease]
    else
      0
    end
  end
end

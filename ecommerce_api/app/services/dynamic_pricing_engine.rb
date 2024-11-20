class DynamicPricingEngine
  def initialize(product)
    @product = product
    @base_price = product.default_price
    @current_price = product.price || product.default_price
  end

  def update_price
    return unless should_update_price?

    # Apply all pricing strategies
    apply_pricing_strategy(Strategies::DemandPricingStrategy.new(@product))
    apply_pricing_strategy(Strategies::InventoryPricingStrategy.new(@product))
    apply_pricing_strategy(Strategies::CompetitorPricingStrategy.new(@product))

    save_updated_price
  end

  private

  def apply_pricing_strategy(strategy)
    # Update price using the given strategy
    @current_price = strategy.update_price(@current_price)
  end

  def save_updated_price
    DynamicPrice.create(product: @product, price: @current_price)
  end

  def should_update_price?
    last_price_update_at.nil? || last_price_update_at < Time.current - pricing_recalculation_interval
  end

  def last_price_update_at
    dynamic_price = DynamicPrice.where(product: @product).order(created_at: :desc).first
    if dynamic_price.present?
      dynamic_price.updated_at
    end
  end

  def pricing_recalculation_interval
    case DynamicPricingConfig.recalc_type
    when "hour"
      interval_in_seconds = DynamicPricingConfig.recalc_interval.hour
    when "minute"
      interval_in_seconds = DynamicPricingConfig.recalc_interval.minute
    when "day"
      interval_in_seconds = DynamicPricingConfig.recalc_interval.day
    when "month"
      interval_in_seconds = DynamicPricingConfig.recalc_interval.month
    when "year"
      interval_in_seconds = DynamicPricingConfig.recalc_interval.year
    else
      raise "Unknown interval type"
    end
  end
end

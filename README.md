# Dynamic Pricing Engine

An intelligent e-commerce dynamic pricing engine that automatically adjusts product prices based on three key factors: inventory levels, market demand, and competitor pricing. The system updates prices hourly using configurable strategies.

## How It Works

The dynamic pricing engine employs three distinct pricing strategies that work together to determine the optimal price for each product. Each strategy can be configured through `ecommerce_api/config/initializers/dynamic_price_engine.rb`.

### 1. Inventory-Based Pricing Strategy
Adjusts prices based on current inventory levels:
- When inventory is low (< 20 units):
  - Increases price by 1% to manage scarcity
- When inventory is high (> 100 units):
  - Decreases price by 0.5% to encourage sales
- Between these thresholds:
  - Maintains current price

```ruby
# Configuration
inventory: {
  thresholds: { low: 20, high: 100 },
  increase: 0.01,     # 1% increase if inventory is low
  decrease: 0.005     # 0.5% decrease if inventory is high
}
```

### 2. Demand-Based Pricing Strategy
Adjusts prices based on product demand:
- During high demand:
  - Increases price by 5%
- During normal/low demand:
  - Maintains current price (0% adjustment)

```ruby
# Configuration
demand: {
  increase: 0.05,     # 5% increase
  decrease: 0         # No decrease during low demand
}
```

### 3. Competitor-Based Pricing Strategy
Adjusts prices relative to competitor prices:
- When competitor price is higher:
  - Sets price 5% higher than competitor
- When competitor price is lower:
  - Sets price 5% lower than competitor
- When prices match:
  - Maintains current price

```ruby
# Configuration
competitor: {
  increase: 0.05,     # 5% higher than competitor price
  decrease: 0.05      # 5% lower than competitor price
}
```

## Price Update Schedule

Prices are automatically updated through a Sidekiq scheduled job:

```yaml
# config/sidekiq.yml
:scheduler:
  :schedule:
    update_competitor_prices:
      cron: "0 * * * *"  # Every hour
      class: UpdateCompetitorPricesJob
```

## Configuration

You can customize the update frequency and pricing rules in `config/initializers/dynamic_price_engine.rb`:

```ruby
DynamicPricingConfig = OpenStruct.new(
  # ... strategy configurations ...
  recalc_interval: 1,       # Frequency number
  recalc_type: "minute"     # minute, hour, day, month, or year
)
```

## Price Calculation Process

1. **Initialization**
   - Engine loads product's base price and current price
   - Checks if price update is needed based on recalc_interval

2. **Strategy Application**
   - Applies each pricing strategy in sequence:
     1. Demand-based adjustment
     2. Inventory-based adjustment
     3. Competitor-based adjustment
   - Each strategy can modify the price based on its rules

3. **Price Updates**
   - Creates a new DynamicPrice record with the calculated price
   - Updates happen only if the recalculation interval has passed

## Example Price Calculation

```ruby
# Starting with a product priced at $100

# 1. Demand Strategy (high demand)
$100 * (1 + 0.05) = $105

# 2. Inventory Strategy (low stock)
$105 * (1 + 0.01) = $106.05

# 3. Competitor Strategy (competitor price at $110)
$106.05 * (1 + 0.05) = $111.35

# Final price: $111.35
```

## API Usage

```bash
# Get current price for a product
GET /api/v1/products/:id
```

## Monitoring

Monitor price updates and job execution:
- View scheduled jobs: http://localhost:3000/sidekiq/recurring-jobs

## Development

To modify pricing strategies:
1. Edit strategy classes in `app/services/strategies/`
2. Update configuration in `config/initializers/dynamic_price_engine.rb`
3. Restart the application to apply changes

## Testing

```bash
bundle exec rspec spec/services/dynamic_pricing_engine_spec.rb
bundle exec rspec spec/services/strategies/*_spec.rb
```
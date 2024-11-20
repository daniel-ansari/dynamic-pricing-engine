DynamicPricingConfig = OpenStruct.new(
  inventory: {
    thresholds: { low: 20, high: 100 },
    increase: 0.01,     # 1% increase if inventory is low
    decrease: 0.005     # 0.5% decrease if inventory is high
  },
  demand: {
    increase: 0.05,     # 5% increase
    decrease: 0
  },
  competitor: {
    increase: 0.05,     # 5% higher than competitor price
    decrease: 0.05      # 5% lower than competitor price
  },
  recalc_interval: 1,   # update price per day
  recalc_type: "minute"   # update price per minute ex: minute, hour, day, month or year
)

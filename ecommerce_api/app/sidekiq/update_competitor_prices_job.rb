class UpdateCompetitorPricesJob
  include Sidekiq::Job

  sidekiq_options queue: "default", retry: 5

  def perform
    response = ::Competitor::Client.new.get(:prices)
    response.data.each_slice(1000) do |items|
      items.each do |item|
        next unless Product.exists?(name: item[:name])

        product = Product.find_by(name: item[:name])
        competitor_price = CompetitorPrice.find_or_initialize_by(product: product)
        competitor_price.price = Money.new(item[:price].to_i)
        competitor_price.save!
      end
    end

    UpdateProductPricesJob.perform_async
  end
end

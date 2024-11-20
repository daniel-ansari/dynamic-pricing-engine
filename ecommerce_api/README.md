# Dynamic Pricing Engine

A robust e-commerce dynamic pricing engine built with Ruby on Rails, featuring automatic price adjustments based on market conditions, competitor pricing, and inventory levels.

## System Requirements

- Ruby 3.2.6
- Redis 6+
- MongoDB 6+
- Bundler

## Features

- 🚀 Real-time price optimization
- 📊 Market demand analysis
- 📈 Competitor price tracking
- 📦 Inventory-based pricing
- 🤖 Automated price updates via Sidekiq
- 📄 Swagger API documentation
- 🔄 CSV import functionality

## Quick Start

### Standard Setup

1. Clone the repository:
```bash
git clone https://github.com/daniel-ansari/dynamic-pricing-engine.git
cd ecommerce_api
```

2. Install dependencies:
```bash
gem install bundler
bundle install
```

3. Configure environment variables:
```bash
cp .env.sample .env
```
Edit `.env` with your configuration settings.

4. Start the Rails server:
```bash
rails s
```

5. In a separate terminal, start Sidekiq:
```bash
bundle exec sidekiq -C config/sidekiq.yml
```

6. Import sample inventory data:
```bash
bin/rails import:inventory_csv
```

### Docker Setup

1. Build and start all services:
```bash
docker compose up --build
```

2. Import sample data (in a new terminal):
```bash
docker compose run -it server_api import
```

## Accessing the Application

- **API Documentation**: [http://localhost:3000/api-docs](http://localhost:3000/api-docs)
- **Sidekiq Dashboard**: [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)
- **Scheduled Jobs**: [http://localhost:3000/sidekiq/recurring-jobs](http://localhost:3000/sidekiq/recurring-jobs)

## API Endpoints

Detailed API documentation is available at `/api-docs` after starting the server. Key endpoints include:

- `GET /api/products` - List all products with current prices
- `GET /api/products/:id` - Get specific product details
- `POST /api/cart/:cart_id` - Add/Update product into cart
see more please go to this
- **API Documentation**: [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

## Background Jobs

The application uses Sidekiq for background processing. Key jobs include:

- Price update scheduler (runs every 6 hours)
- Competitor price tracking
- Inventory level monitoring
- Market demand analysis

## Development

### Running Tests

```bash
bundle exec rspec
```

## Docker Components

The `docker-compose.yml` includes:

- Rails application server
- MongoDB
- Redis
- Sidekiq worker
- Nginx (for production)

## Deployment

For production deployment, ensure you:

1. Set proper environment variables
2. Configure MongoDB authentication
3. Set up SSL certificates
4. Configure proper Redis security
5. Set up monitoring (NewRelic, Datadog, etc.)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Support

For support, please open an issue in the GitHub repository or contact the development team.
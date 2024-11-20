module API
  class ProductsController < API::APIController
    def index
      links, products = paginate(Product.all)

      render json: ProductBlueprint.render(products, root: :products, meta: { links: links })
    end

    def show
      product = Product.find(params[:id])
      render json: ProductBlueprint.render(product, root: :product)
    end
  end
end

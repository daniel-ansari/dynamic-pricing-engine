module API
  class CartController < API::APIController
    before_action :find_order

    def create
      product = Product.find(cart_params[:product_id])
      quantity = cart_params[:quantity].to_i
      order_item = @order.order_items.find_or_initialize_by(product: product)
      order_item.quantity += quantity
      order_item.price = product.price
      order_item.save!

      render json: OrderBlueprint.render(@order, root: :cart)
    end

    # Get cart by ID
    def show
      render json: OrderBlueprint.render(@order, root: :cart)
    end

    def destroy
      @order.destroy

      head :no_content
    end

    def remove_item
      if @order.order_items.any?
        order_item = @order.order_items.find(params[:order_item_id])
        order_item.destroy
      end

      render json: OrderBlueprint.render(@order, root: :cart)
    end

    private

    def find_order
      @order = Order.find_by(id: params[:id], status: "cart") if params[:id].present?
      @order ||= Order.create
    end

    def cart_params
      params.require(:cart).permit(:product_id, :quantity)
    end
  end
end

class API::OrdersController < API::APIController
  before_action :find_order

  def create
    @order.place_order!
    render json: OrderBlueprint.render(@order, root: :order), status: @order.completed? ? :ok : :unprocessable_entity
  end

  def destroy
    @order.cancel!
    render json: OrderBlueprint.render(@order, root: :order)
  end

  private

  def find_order
    @order = Order.find_by(id: params[:cart_id], status: "cart")
  end
end

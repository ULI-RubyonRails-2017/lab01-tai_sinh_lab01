class OrdersController < ApplicationController
  def show_cart
    @cart_items = Hash.new

    @delivery_cost = 20000
    @total_cost = @delivery_cost

    begin
      @cart = JSON.parse(URI.unescape(cookies[:cart]))
      if @cart != nil
        @cart.each do |k, v|
          item = MenuItem.find(k)
          if item != nil
            @cart_items[k] = Hash.new
            @cart_items[k]["id"] = k
            @cart_items[k]["name"] = item.name
            @cart_items[k]["price"] = item.price
            @cart_items[k]["quantity"] = v
            @cart_items[k]["total"] = v * item.price
            @total_cost += @cart_items[k]["total"]
          end
        end
      end
    rescue

    end

    cookies[:cart_items_json] = URI.escape(JSON.generate(@cart_items))
  end

  def create
    anOrder = Order.new
    anOrder.user_name = params[:user_name]
    anOrder.address = params[:address]
    anOrder.phone = params[:phone]
    anOrder.cart_items = URI.unescape(cookies[:cart_items_json])
    anOrder.delivery_cost = params[:delivery_cost]
    anOrder.total_cost = params[:total_cost]
    if anOrder.save
      redirect_to controller: 'thank_you', action: 'index', order_id: anOrder.id
    else
      render "something_wrong/index"
    end
  end
end

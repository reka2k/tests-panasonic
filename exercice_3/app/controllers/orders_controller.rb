class OrdersController < ApplicationController
  def index
    @orders = OrderDetail.all.order(confirmed_delay: :asc)
  end
end

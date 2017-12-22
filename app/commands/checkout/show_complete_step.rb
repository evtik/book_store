module Checkout
  class ShowCompleteStep < BaseCommand
    def self.build
      new(UserLastOrder, Common::GetUserIdFromSession.build)
    end

    def initialize(*args)
      @last_order_query, @get_user_id = args
    end

    def call(session, flash)
      return publish(:denied, cart_path) unless flash[:order_confirmed]
      flash.keep
      order = @last_order_query.new(@get_user_id.call(session)).first.decorate
      publish(:ok, order: order, order_items: order.order_items)
    end
  end
end

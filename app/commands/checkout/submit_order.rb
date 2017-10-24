module Checkout
  class SubmitOrder < BaseCommand
    def self.build
      new(Checkout::BuildCompletedOrder.build)
    end

    def initialize(build_completed_order)
      @build_completed_order = build_completed_order
    end

    def call(session)
      order = @build_completed_order.call(session)
      if order.save
        begin
          %i(cart order discount coupon_id).each { |key| session.delete(key) }
          NotifierMailer.order_email(order).deliver
        ensure
          publish(:ok)
        end
      else
        publish(:error, order.errors.full_messages.first)
      end
    end
  end
end

module Checkout
  class SubmitOrder < BaseCommand
    def self.build
      new(Checkout::BuildCompletedOrder.build, NotifierMailer)
    end

    def initialize(*args)
      @build_order, @mailer = args
    end

    def call(session)
      order = @build_order.call(session)
      return publish(:error, order.errors.full_messages.first) unless order.save
      begin
        %i(cart order discount coupon_id).each { |key| session.delete(key) }
        @mailer.order_email(order).deliver
      ensure
        publish(:ok)
      end
    end
  end
end

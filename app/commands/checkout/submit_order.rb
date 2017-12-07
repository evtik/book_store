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
      return publish(:error) unless order.save
      %i(cart order discount coupon_id).each { |key| session.delete(key) }
      @mailer.order_email(order).deliver
    rescue StandardError => error
      Rails.logger.debug(error.inspect)
    ensure
      publish(:ok)
    end
  end
end

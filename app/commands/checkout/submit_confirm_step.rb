module Checkout
  class SubmitConfirmStep < BaseCommand
    def self.build
      new(Checkout::BuildCompletedOrder.build, NotifierMailer)
    end

    def initialize(*args)
      @build_order, @mailer = args
    end

    def call(session, _params, flash)
      @order = @build_order.call(session)
      @order.save ? handle_success(session, flash) : handle_error(flash)
    end

    private

    def handle_success(session, flash)
      %i(cart order discount coupon_id).each { |key| session.delete(key) }
      @mailer.order_email(@order).deliver
    rescue StandardError => error
      Rails.logger.debug(error.inspect)
    ensure
      flash[:order_confirmed] = true
      publish(:ok, checkout_complete_path)
    end

    def handle_error(flash)
      flash[:alert] = I18n.t('checkout.submit_confirm.order_placement_error')
      publish(:error, checkout_confirm_path)
    end
  end
end

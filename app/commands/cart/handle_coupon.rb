module Cart
  class HandleCoupon < BaseCommand
    def self.build
      new(Cart::GetCouponError.build)
    end

    def initialize(get_coupon_error)
      @get_coupon_error = get_coupon_error
    end

    def call(coupon_code)
      coupon = Coupon.where(code: coupon_code).first
      coupon_states = [coupon.nil?, coupon&.order.present?]
      coupon_states << (coupon.expires < Date.today) unless coupon_states.any?
      if coupon_states.any?
        publish(:error, @get_coupon_error.call(coupon_states))
      else
        publish(:ok, coupon)
      end
    end
  end
end

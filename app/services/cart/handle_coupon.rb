module Cart
  class HandleCoupon
    def self.call(coupon_code)
      return if coupon_code.blank?
      coupon = Coupon.where(code: coupon_code).first
      coupon_states = [coupon.nil?, coupon&.order.present?]
      coupon_states << (coupon_states.any? ? nil : coupon.expires < Date.today)
      coupon_states.any? ? coupon_message : coupon_discount
    end
  end
end

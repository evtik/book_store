module Cart
  class GetCouponError < BaseService
    def call(coupon_states)
      {
        [true, false] => I18n.t('coupon.non_existent'),
        [false, true] => I18n.t('coupon.taken'),
        [false, false, true] => I18n.t('coupon.expired')
      }[coupon_states]
    end
  end
end

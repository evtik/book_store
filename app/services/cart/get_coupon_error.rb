module Cart
  class GetCouponError < BaseService
    include AbstractController::Translation

    def call(coupon_states)
      {
        [true, false] => t('coupon.non_existent'),
        [false, true] => t('coupon.taken'),
        [false, false, true] => t('coupon.expired')
      }[coupon_states]
    end
  end
end

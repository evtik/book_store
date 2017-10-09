class HandleCoupon < Rectify::Command
  def initialize(coupon_code)
    @coupon_code = coupon_code
  end

  def call
    coupon = Coupon.where(code: @coupon_code).first
    @coupon_states = [coupon.nil?, coupon&.order.present?]
    @coupon_states << (@coupon_states.any? ? nil : coupon.expires < Date.today)
    if @coupon_states.any?
      publish(:invalid, coupon_message)
    else
      publish(:valid, coupon)
    end
  end

  private

  def coupon_message
    coupon_messages = {
      [false, true, nil] => I18n.t('coupon.taken'),
      [false, false, true] => I18n.t('coupon.expired'),
      [true, false, nil] => I18n.t('coupon.non_existent')
    }
    coupon_messages[@coupon_states]
  end
end

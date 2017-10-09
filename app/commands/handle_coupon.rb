class HandleCoupon < Rectify::Command
  def initialize(coupon_code)
    @coupon_code = coupon_code
  end

  def call
    coupon = Coupon.where(code: @coupon_code).first
    @coupon_states = [coupon.nil?, coupon&.order.present?]
    @coupon_states << (coupon.expires < Date.today) unless @coupon_states.any?
    @coupon_states.any? ? publish(:error, message) : publish(:ok, coupon)
  end

  private

  def message
    coupon_messages = {
      [false, true] => I18n.t('coupon.taken'),
      [false, false, true] => I18n.t('coupon.expired'),
      [true, false] => I18n.t('coupon.non_existent')
    }
    coupon_messages[@coupon_states]
  end
end

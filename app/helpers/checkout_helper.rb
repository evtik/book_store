module CheckoutHelper
  STEPS = %w(address delivery payment confirm complete).freeze
  CVV_HINT = '3-digit security code usually found on the back of your'\
    ' card. American Express cards have a 4-digit code located on'\
    ' the front.'.freeze

  def previous?(step)
    STEPS.index(step) < STEPS.index(action_name)
  end

  def current?(step)
    STEPS.index(step) == STEPS.index(action_name)
  end
end

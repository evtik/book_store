module CheckoutHelper
  STEPS = %w(address delivery payment confirm complete).freeze

  def previous?(step)
    STEPS.index(step) < STEPS.index(action_name)
  end

  def current?(step)
    STEPS.index(step) == STEPS.index(action_name)
  end
end

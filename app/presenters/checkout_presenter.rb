class CheckoutPresenter < Rectify::Presenter
  STEPS = %w(address delivery payment confirm complete).freeze

  def steps
    STEPS
  end

  def previous?(step, action)
    STEPS.index(step) < STEPS.index(action)
  end

  def current?(step, action)
    STEPS.index(step) == STEPS.index(action)
  end
end

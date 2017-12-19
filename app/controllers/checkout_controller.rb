class CheckoutController < ApplicationController
  include Rectify::ControllerHelpers

  STEPS = [:address, :delivery, :payment, :confirm, :complete].freeze

  before_action :authenticate_user!
  before_action -> { present CheckoutPresenter.new }, only: STEPS

  STEPS.each do |step|
    define_method step do
      "Checkout::Show#{step.capitalize}Step".constantize.call(session, flash) do
        on(:ok) { |step_variables| expose step_variables }
        on(:denied) { |failure_path| redirect_to failure_path }
      end
    end

    next if step == :complete

    define_method "submit_#{step}" do
      command = "Checkout::Submit#{step.capitalize}Step".constantize
      command.call(session, params, flash) do
        on(:ok) { |ok_path| redirect_to ok_path }
        on(:error) { |error_path| redirect_to error_path }
      end
    end
  end
end

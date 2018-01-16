class SettingsController < ApplicationController
  before_action(:authenticate_user!, -> { @countries = COUNTRIES })

  def show
    @billing = Common::GetOrCreateAddress.call(session, 'billing')
    @shipping = Common::GetOrCreateAddress.call(session, 'shipping')
  end
end

class SettingsController < ApplicationController
  before_action :authenticate_user!, -> { @countries = COUNTRIES }

  def show
    @billing = Common::GetOrCreateAddress.call(current_user.id, 'billing')
    @shipping = Common::GetOrCreateAddress.call(current_user.id, 'shipping')
  end
end

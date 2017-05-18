class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @billing = AddressForm.new
    @shipping = AddressForm.new
    @countries = Country.all.map { |c| [c.name, c.country_code] }
  end
end

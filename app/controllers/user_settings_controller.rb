class UserSettingsController < ApplicationController
  before_action :authenticate_user!, :populate_countries

  def show
    @billing = fetch_or_create_address('billing')
    @shipping = fetch_or_create_address('shipping')
    @countries = COUNTRIES
  end

  def update
    # @billing = AddressForm.from_params(params.permit![:address][:billing].to_h)
    # @shipping = AddressForm.from_params(params.permit![:address][:shipping].to_h)
    b_params = params.permit![:address][:billing].to_h
    p_params = params.permit![:address][:shipping].to_h
    b_double = Address.new(b_params)
    p_double = Address.new(p_params)
    @billing = AddressForm.from_model(b_double)
    @shipping = AddressForm.from_model(p_double)
    byebug
    if @shipping.valid?
      Address.new(params.permit![:address][:shipping]).save
    else
      render :show
    end
  end

  private

  def populate_countries
    @countries = COUNTRIES
  end
end

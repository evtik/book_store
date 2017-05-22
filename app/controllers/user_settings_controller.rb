class UserSettingsController < ApplicationController
  before_action :authenticate_user!, :populate_countries

  def show
    @billing = fetch_or_create_address('billing')
    @shipping = fetch_or_create_address('shipping')
  end

  def update_address
    addresses_from_params
    @current_type = params.permit(:billing, :shipping).to_h.key('Save')
    @current_address = instance_variable_get("@#{@current_type}")
    return render :show if @current_address.invalid?
    address = find_or_initialize_address
    flash[:error] = "Error saving #{@current_type} address" unless address.save
    redirect_to action: :show
  end

  def update_email
    user = User.find(current_user.id)
    user.email = params.require(:user).permit(:email)[:email]
    flash[:show_privacy] = true
    flash[:success] = 'Your email has been successfully updated' if user.save
    flash[:error] = user.errors.full_messages.first unless user.save
    redirect_to action: :show
  end

  private

  def populate_countries
    @countries = COUNTRIES
  end

  def addresses_from_params
    @billing = AddressForm.from_params(params[:address][:billing])
    @shipping = AddressForm.from_params(params[:address][:shipping])
  end

  def find_or_initialize_address
    address = Address.find_or_initialize_by(id: @current_address.id)
    address.attributes = permitted(@current_type)
    address.user_id ||= params.permit(:id)[:id]
    address.address_type = @current_type if address.address_type.blank?
    address
  end

  def permitted(type)
    params.require(:address).require(type.to_sym).permit(
      :user_id, :first_name, :last_name, :street_address,
      :city, :zip, :country, :phone, :address_type
    )
  end
end

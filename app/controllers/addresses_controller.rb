class AddressesController < ApplicationController
  before_action :authenticate_user!, -> { @countries = COUNTRIES }

  def update
    addresses_from_params
    @current_type = params.permit(:billing, :shipping)
                          .to_h.key(t('settings.show.save'))
    @current_address = instance_variable_get("@#{@current_type}")
    return render 'settings/show' if @current_address.invalid?
    if find_or_initialize_address.save
      flash[:notice] = t(
        'settings.show.address_saved',
        address_type: t("checkout.address.#{@current_type}")
      )
    end
    redirect_to settings_path
  end

  private

  def addresses_from_params
    @billing = AddressForm.from_params(params[:address][:billing])
    @shipping = AddressForm.from_params(params[:address][:shipping])
  end

  def find_or_initialize_address
    address = Address.find_or_initialize_by(id: @current_address.id)
    address.attributes = settings_params(@current_type)
    address.user_id ||= current_user.id
    address.address_type = @current_type if address.address_type.blank?
    address
  end

  def settings_params(type)
    params.require(:address).require(type.to_sym).permit(
      :user_id, :first_name, :last_name, :street_address,
      :city, :zip, :country, :phone, :address_type
    )
  end
end

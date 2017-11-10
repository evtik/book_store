class AddressesController < ApplicationController
  before_action :authenticate_user!

  def update
    Settings::UpdateAddress.call(params.permit!.to_h, current_user.id) do
      on(:invalid) { |address| session[:address] = address }
      on(:ok) { |message| flash[:notice] = message }
      on(:error) { |error_message| flash[:alert] = error_message }
    end
    redirect_to settings_path
  end
end

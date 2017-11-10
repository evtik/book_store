module Settings
  class GetAddressFromSession < BaseService
    def call(session)
      address = AddressForm.from_params(session[:address]).tap(&:valid?)
      session.delete(:address)
      address
    end
  end
end

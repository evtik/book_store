module Common
  class GetOrCreateAddress < BaseService
    def self.build
      new(Settings::GetAddressFromSession, Common::GetUserIdFromSession)
    end

    def initialize(*args)
      @get_address_from_session, @get_user_id = args
    end

    def call(session, address_type)
      if session[:address] && session[:address]['address_type'] == address_type
        return @get_address_from_session.call(session)
      end
      user_id = @get_user_id.call(session)
      address = Address.find_by(user_id: user_id, address_type: address_type)
      if address
        AddressForm.from_model(address)
      else
        AddressForm.new(address_type: address_type)
      end
    end
  end
end

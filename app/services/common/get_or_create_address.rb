module Common
  class GetOrCreateAddress < BaseService
    def call(user_id, address_type)
      address = Address.find_by(user_id: user_id, address_type: address_type)
      if address
        AddressForm.from_model(address)
      else
        AddressForm.new(address_type: address_type)
      end
    end
  end
end

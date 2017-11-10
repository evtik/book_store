module Settings
  class UpdateAddress < BaseCommand
    def self.build
      new(
        Settings::FindOrInitializeAddress.build,
        Settings::GenerateAddressUpdatedMessage.build
      )
    end

    def initialize(*args)
      @find_init_address, @address_updated_message = args
    end

    def call(params, user_id)
      address_type = params.key(t('settings.show.save'))
      address = AddressForm.from_params(params[:address][address_type])
      return publish(:invalid, address) if address.invalid?
      address = @find_init_address.call(address.id, address.to_h,
                                        user_id, address_type)
      if address.save
        publish(:ok, @address_updated_message.call(address_type))
      else
        publish(:error, address.errors.full_messages.first)
      end
    end
  end
end

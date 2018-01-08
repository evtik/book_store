module Settings
  class GenerateAddressUpdatedMessage < BaseService
    def call(type)
      t('settings.show.address_saved',
        address_type: I18n.t("checkout.address.#{type}"))
    end
  end
end

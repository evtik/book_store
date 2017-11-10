module Settings
  class GenerateAddressUpdatedMessage < BaseService
    include AbstractController::Translation

    def call(type)
      t('settings.show.address_saved',
        address_type: t("checkout.address.#{type}"))
    end
  end
end

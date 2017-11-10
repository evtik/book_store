module Settings
  class FindOrInitializeAddress < BaseService
    def call(id, attributes, user_id, address_type)
      Address.find_or_initialize_by(id: id).tap do |address|
        address.attributes = attributes
        address.user_id ||= user_id
        address.address_type = address_type if address.address_type.blank?
      end
    end
  end
end

module Settings
  class FindOrInitializeAddress < BaseService
    def call(attributes, user_id)
      Address.find_or_initialize_by(id: attributes[:id]).tap do |address|
        address.attributes = attributes
        address.user_id ||= user_id
      end
    end
  end
end

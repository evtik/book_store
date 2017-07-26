class UserAddress < Rectify::Query
  def initialize(id, type)
    @id = id
    @type = type
  end

  def query
    Address.where(user_id: @id, address_type: @type)
  end
end

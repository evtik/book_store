class ShipmentForm < Rectify::Form
  attribute :method, String
  attribute :days_min, Integer
  attribute :days_max, Integer
  attribute :price, Decimal
end

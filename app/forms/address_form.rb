class AddressForm
  include ActiveModel::Model
  include Virtus.model

  attr_reader :address

  attribute :firstname, String
  attribute :lastname, String
  attribute :address, String
  attribute :city, String
  attribute :zip, String
  attribute :country, String
  attribute :phone, String

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :phone, presence: true
end

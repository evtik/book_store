class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy, autosave: false
  has_many :billing_addresses, -> { where(address_type: 'billing') },
           class_name: 'Address'

  after_create :send_welcome_user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable, :recoverable, :rememberable,
         :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.addresses << Address.new(
        first_name: auth.info.first_name,
        last_name: auth.info.last_name,
        city: auth.info.hometown,
        address_type: 'billing'
      )
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def send_welcome_user
    NotifierMailer.user_email(self).deliver
  end
end

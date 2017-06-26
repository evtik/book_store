class ApplicationController < ActionController::Base
  COUNTRIES = Country.all.map { |c| [c.name, c.country_code] }

  protect_from_forgery with: :exception
  before_action :fetch_categories
  before_action :store_current_location, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do
    render file: "#{Rails.root}/public/403.html", staus: 403, layout: false
  end

  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.admin?
    flash[:alert] = 'You are not authorized to access this resource'
    redirect_to root_path
  end

  def order_items_from_cart
    session[:cart].map do |book_id, quantity|
      OrderItem.new do |order_item|
        order_item.book_id = book_id
        order_item.quantity = quantity.to_i
      end
    end
  end

  def fetch_or_create_address(type)
    address = UserAddress.new(current_user.id, type).first
    if address
      AddressForm.from_model(address)
    else
      AddressForm.new(address_type: type)
    end
  end

  private

  def fetch_categories
    @categories = CategoriesCounter.new.to_a
  end

  def store_current_location
    store_location_for(:user, request.url)
  end
end

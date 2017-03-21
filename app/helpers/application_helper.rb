module ApplicationHelper
  def cart_items_count
    return session[:cart].length if session[:cart]
    0
  end
end

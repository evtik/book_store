module ApplicationHelper
  def cart_items_count
    return session[:cart].length if session[:cart]
    0
  end

  def permitted
    params.permit(:category, :sort_by, :order, :limit)
  end

  def capitalize_category(name)
    name.split.map(&:capitalize).join(' ')
  end
end

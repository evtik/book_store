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

  def book_image_path(path)
    "https://s3.eu-central-1.amazonaws.com/sybookstore/images/#{path}.png"
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    Redcarpet::Markdown.new(renderer).render(text)
  end

  def verified_reviewer?(book_id, user_id)
    OrderItem.eager_load(order: :user)
             .exists?(book_id: book_id, 'orders.user_id' => user_id)
  end
end

OrderItem.destroy_all
Shipment.destroy_all
CreditCard.destroy_all
Coupon.destroy_all
Order.destroy_all
Review.destroy_all
Book.destroy_all
Category.destroy_all
Material.destroy_all
Author.destroy_all
User.destroy_all

User.create! do |u|
  u.email = 'admin@bookstore.com'
  u.password = '11111111'
  u.admin = true
end

100.times do |i|
  User.create do |user|
    user.email = "user#{i}@example.com"
    user.password = '11111111'
  end
end

['mobile development', 'photo', 'web design', 'web development'].each do |item|
  Category.create! do |category|
    category.name = item
  end
end

materials = ['hardcover', 'paperback', 'leather', 'vinyl', 'ivory',
             'off-white paper', 'low-white paper', 'glossy paper']

materials.each do |item|
  Material.create! do |material|
    material.name = item
  end
end

50.times do
  author = Author.new
  author.first_name = Faker::Name.first_name
  author.last_name = Faker::Name.last_name
  author.description = Faker::Hipster.paragraph(3, false, 5)
  author.save!
end

categories = Category.all
materials = Material.all
authors = Author.all

num_books = 200

num_books.times do |i|
  book = Book.new
  book.title = Faker::Book.title.truncate(70)
  book.year = (1997..2016).to_a.sample
  book.description = Faker::Hipster.paragraph(9, false, 17).truncate(990)
  book.height = rand(8..15)
  book.width = rand(4..7)
  book.thickness = rand(1..3)
  book.category = categories.sample
  book.price = (rand(4.99..119.99) * 20).round / 20.0
  book.materials.concat [materials[rand(0..4)], materials[rand(5..7)]]
  if (i % 3).zero?
    book.authors.concat authors.sample(rand(1..3))
  else
    book.authors << authors.sample
  end
  book.created_at = DateTime.now - (num_books - i).days
  book.save!
end

users = User.where(admin: nil)
review_states = %w(unprocessed approved rejected)
books = Book.all
books.each do |book|
  users.sample(rand(0..5)).each do |user|
    Review.create! do |review|
      review.book = book
      review.user = user
      review.score = rand(1..5)
      review.title = Faker::Hipster.sentence.truncate(70)
      review.body = Faker::Hipster.paragraph(8, false, 10).truncate(490)
      review.state = review_states.sample
    end
  end
end

num_codes = 30
codes = Set.new
codes << rand(10**6).to_s while codes.length < num_codes

codes.each do |code|
  Coupon.create! do |coupon|
    coupon.code = code
    coupon.expires = DateTime.now + rand(1..60).days
    coupon.discount = rand(1..15)
  end
end

@countries = Country.all.map { |country| [country.name, country.country_code] }

def create_address(type)
  address = Address.new
  address.first_name = Faker::Name.first_name
  address.last_name = Faker::Name.last_name
  address.street_address = Faker::Address.street_address
  address.city = Faker::Address.city
  address.zip = Faker::Address.zip
  country = @countries.sample
  address.country = country.first
  address.phone = '+' << country.last <<
    Faker::PhoneNumber.subscriber_number(rand(10..(15 - country.last.length)))
  address.address_type = type
  address
end

booleans = [true, false]

users.each do |user|
  user.addresses << create_address('billing')
  user.addresses << create_address('shipping') if booleans.sample
  user.save!
end

[
  { method: 'Delivery next day!', days_min: 3, days_max: 7, price: 5.00 },
  { method: 'Pick Up In-Store', days_min: 5, days_max: 20, price: 10.00 },
  { method: 'Expressit', days_min: 2, days_max: 3, price: 15.00 }
].each { |shipment| Shipment.create!(shipment) }

num_orders = 500
order_states = %w(in_progress in_queue in_delivery delivered canceled)
shipments = Shipment.all
months = %w(01 02 03 04 05 06 07 08 09 10 11 12)

num_orders.times do |order_index|
  order = Order.new
  order.shipment = shipments.sample
  order.state = order_states.sample
  order.user = users.sample
  if (order_index % 20).zero?
    order.coupon = Coupon.includes(:order)
                         .where('orders.coupon_id' => nil)
                         .sample
  end
  card = CreditCard.new
  card.number = Faker::Business.credit_card_number
  card.month_year = "#{months.sample}/#{rand(18..20)}"
  card.cardholder = 'John Doe'
  card.cvv = Array.new(rand(3..4)) { rand(0..9) }.join
  order.credit_card = card

  if (order_index % 7).zero?
    order_item = OrderItem.new
    order_item.book = books[0..2].sample
    order_item.quantity = rand(1..4)
    order.order_items << order_item
    books[3..-1].sample(rand(0..4)).each do |book|
      order_item = OrderItem.new
      order_item.book = book
      order_item.quantity = rand(1..4)
      order.order_items << order_item
    end
  else
    books.sample(rand(1..5)).each do |book|
      order_item = OrderItem.new
      order_item.book = book
      order_item.quantity = rand(1..4)
      order.order_items << order_item
    end
  end

  subtotal = order.order_items.sum do |oi|
    oi.book.price * oi.quantity
  end
  subtotal *= (1 - order.coupon.discount / 100) if order.coupon&.discount
  order.subtotal = subtotal
  order.addresses << create_address('billing')
  order.addresses << create_address('shipping') if booleans.sample
  order.created_at = DateTime.now - (num_orders - order_index).hours
  order.save!
end

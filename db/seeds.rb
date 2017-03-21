# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

OrderItem.delete_all
Order.delete_all
Shipment.delete_all
CreditCard.delete_all
Coupon.delete_all
Review.delete_all
User.delete_all
Book.delete_all
Category.delete_all
Material.delete_all
Author.delete_all

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
  Author.create! do |author|
    author.firstname = Faker::Name.first_name
    author.lastname = Faker::Name.last_name
    author.description = Faker::Hipster.paragraph(5, false, 2)
  end
end

categories = Category.all
materials = Material.all
authors = Author.all

num_books = 200

num_books.times do |i|
  Book.create! do |book|
    book.title = Faker::Book.title
    book.year = (1997..2016).to_a.sample
    book.description = Faker::Hipster.paragraph(4, false, 2)
    book.height = rand(8..10)
    book.width = rand(4..7)
    book.thickness = rand(1..3)
    book.category = categories.sample
    book.price = rand(4.99..119.99)
    book.materials.concat [materials[rand(0..4)], materials[rand(5..7)]]
    if (i % 3).zero?
      book.authors.concat authors.sample(rand(1..3))
    else
      book.authors << authors.sample
    end
    book.created_at = DateTime.now - (num_books - i).days
  end
end

users = User.where(admin: nil)
# puts "users count is #{users.count}"
review_states = %w(unprocessed approved rejected)
books = Book.all
# puts "books count is #{books.count}"
books.each do |book|
  users.sample(rand(0..5)).each do |user|
    Review.create! do |review|
      review.book = book
      review.user = user
      review.score = rand(1..5)
      review.title = Faker::Hipster.sentence
      review.body = Faker::Hipster.paragraph(3, false, 1)
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

def create_address(type)
  address = Address.new
  address.firstname = Faker::Name.first_name
  address.lastname = Faker::Name.last_name
  address.address = Faker::Address.street_address
  address.city = Faker::Address.city
  address.zip = Faker::Address.zip
  address.country = Faker::Address.country
  address.phone = '+' << Faker::PhoneNumber.subscriber_number(rand(12..15))
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
  # if (order_index % 20).zero?
    # Coupon.where(order_id: nil).sample.order = order
  # end
  card = CreditCard.new
  card.number = Faker::Business.credit_card_number
  card.month_year = "#{months.sample}/#{rand(18..20)}"
  card.cardholder = 'John Doe'
  card.cvv = Array.new(rand(3..4)) { rand(0..9) }.join
  # breaks here ...
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

  order.created_at = DateTime.now - (num_orders - order_index).hours
  order.save!
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.delete_all

User.create! do |u|
  u.email = 'admin@bookstore.com'
  u.password = '11111111'
  u.admin = true
end

Category.delete_all
Material.delete_all
Author.delete_all
Book.delete_all

['Mobile development', 'Photo', 'Web design', 'Web development'].each do |item|
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

200.times do |i|
  Book.create! do |book|
    book.title = Faker::Book.title
    book.year = (1997..2016).to_a.sample
    book.description = Faker::Hipster.paragraph(4, false, 2)
    book.height = (8..10).to_a.sample
    book.width = (4..7).to_a.sample
    book.thickness = (1..3).to_a.sample
    book.category = categories.sample
    book.materials.concat [materials[rand(0..4)], materials[rand(5..7)]]
    if (i % 3).zero?
      book.authors.concat authors.sample(rand(1..3))
    else
      book.authors << authors.sample
    end
  end
end

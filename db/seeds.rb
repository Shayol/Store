# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Admin.create({email: "admin@gmail.com", password: "password"})
categories = Category.create([{title: "Fantasy"}, {title: "Science Fiction"}])
authors = Author.create([{firstname: "Robert", lastname: "Heinlein"}, {firstname: "Ray", lastname: "Bradbury"}, {firstname: "Greg", lastname: "Egan"}, {firstname: "Roger", lastname: "Zelazny"}, {firstname: "Alfred", lastname: "Bester"}, {firstname: "Richard", lastname: "Morgan"}])
Book.create([{title: "Distress", price: 0.1, amount: 1, author: authors[2], category: categories.last}, {title: "Fahrenheit 451", price: 0.1, amount: 1, author: authors[1], category: categories.last}, {title: "Tiger! Tiger!", price: 0.1, amount: 1, author: authors[-2], category: categories.last}, {title: "Stranger in a Strange Land", price: 0.1, amount: 1, author: authors[0]}, {title: "Magic, Inc", price: 0.1, amount: 1, author: authors[0], category: categories.first}, {title: "Have Space Suit - Will Travel", price: 0.1, amount: 1, author: authors[0], category: categories.last}, {title: "Woken Furies", price: 0.1, amount: 1, author: authors[-1]}, {title: "Nine Princes in Amber", price: 0.1, amount: 1, author: authors[-3]}, {title: "This Immortal", price: 0.1, amount: 1, author: authors[-3]}, { title: "Dandelion Wine", price: 0.1, amount: 1, author: authors[1]}])
Delivery.create([{description: "NewPost One Week", price: 5.00}, {description: "NewPost Two Days", price: 10.00}, {description: "NewPost One Day", price: 15.00}])

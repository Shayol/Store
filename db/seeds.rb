# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Admin.create({email: "Vorga88@gmail.com", password: "password"})
authors = Author.create([{firstname: "Robert", lastname: "Heinlein"}, {firstname: "Ray", lastname: "Bradbury"}, {firstname: "Greg, lastname: Egan"}, {firstname: "Roger", lastname: "Zelazny"}, {firstname: "Alfred", lastname: "Bester"}, {firstname: "Richard", lastname: "Morgan"}])
Book.create([{title: "Distress", price: 0.1, amount: 1, author: authors[2]}, {title: "Fahrenheit 451", price: 0.1, amount: 1, author: authors[1]}, {title: "Tiger! Tiger!", price: 0.1, amount: 1, author: authors[-2]}, {title: "Stranger in a Strange Land", price: 0.1, amount: 1, author: authors[0]}, {title: "Magic, Inc", price: 0.1, amount: 1, author: authors[0]}, {title: "Have Space Suit - Will Travel", price: 0.1, amount: 1, author: authors[0]}, {title: "Woken Furies", price: 0.1, amount: 1, author: authors[-1]}, {title: "Nine Princes in Amber", price: 0.1, amount: 1, author: authors[-3]}, {title: "This Immortal", price: 0.1, amount: 1, author: authors[-3]}])
Delivery.create([{description: "NewPost One Week", price: 5.00}, {description: "NewPost Two Days", price: 10.00}, {description: "NewPost One Day", price: 15.00}])
Country.create([{name: "United States of America"}, {name: "Ukraine"}])
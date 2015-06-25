== README

##Business logic structure:

Book

    Should contain title, descirption, price and how many books in stock
    Title, price, books in stock fields should be required
    Should belong to author and category
    Should have many ratings from costomers

Category

    Has a title
    Title should be required and unique
    Should have many books

Author

    Should contain firstname, lastname, biography
    Firstname, lastname fields should be required
    Should have many books

Rating

    Should contain text review and rating number from one to ten
    Should belong to customer and book

Customer

    Should contain email, password, firstname, lastname
    Email, password, firstname, lastname fields should be required
    Email should be unique
    Should have many orders, ratings
    A customer should be able to create a new order
    A customer should be able to return a current order in progress

Order

    Should contain total price, completed date and state (in progress/complited/shipped)
    Total price, completed date and state fields should be required
    By default an order should have 'in progress' state
    Should belong to customer and credit card
    Should have many order items
    Should have one billing address and one shipping address
    An order should be able to add a book to the order
    An order should be able to return a total price of the order

OrderItem

    Should contain price and quantity
    Price and quantity fields should be required
    Should belong to book and order

Address

    Should contain address, zipcode, city, phone, country
    All fields should be required

Country

    Should contain a name
    Name should be required and unique

CreditCard

    Should contain number, CVV, expiration month, expiration year, firstname, lastname
    All fields should be required
    Should belong to customer and have many orders

Necessary to create a DB structure, models, associations and validations to models, autotests and factories for autotests.
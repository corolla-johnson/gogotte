Feature: Shopping Cart Functionality
  As a customer
  I want to add items to my shopping cart
  So that I can purchase them later

  Background:
    Given the store has the following items:
      | name      | price | stock |
      | Apple     | 1.00  | 10    |
      | Banana    | 0.50  | 15    |
      | Orange    | 0.75  | 8     |
    And I have an empty shopping cart

  Scenario: Adding an item to the cart
    When I add 2 "Apple" to my cart
    Then my cart should contain 2 "Apple"
    And my cart total should be 2.00

  Scenario: Adding multiple items to the cart
    When I add 3 "Apple" to my cart
    And I add 2 "Banana" to my cart
    Then my cart should contain 3 "Apple"
    And my cart should contain 2 "Banana"
    And my cart total should be 4.00

  Scenario: Removing items from the cart
    When I add 3 "Apple" to my cart
    And I add 2 "Banana" to my cart
    And I remove 1 "Apple" from my cart
    Then my cart should contain 2 "Apple"
    And my cart should contain 2 "Banana"
    And my cart total should be 3.00

  Scenario: Attempting to add out-of-stock items
    Given "Orange" has 0 items in stock
    When I try to add 2 "Orange" to my cart
    Then I should see an "Out of stock" error
    And my cart should be empty

  Scenario: Adding items from a wishlist
    When I import my wishlist with the following items:
      """
      [
        {"name": "Apple", "quantity": 3},
        {"name": "Banana", "quantity": 2},
        {"name": "Orange", "quantity": 1}
      ]
      """
    Then my cart should contain 3 "Apple"
    And my cart should contain 2 "Banana"
    And my cart should contain 1 "Orange"
    And my cart total should be 4.75

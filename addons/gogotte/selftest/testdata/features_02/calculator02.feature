Feature: Calculator
  As a user
  I want to use a calculator
  So that I can perform basic arithmetic operations

  Scenario: Addition
    Given x is equal to 5
    And y is equal to 7
    When we add x and y
    Then the result should be 12

  Scenario: Subtraction
    Given x is equal to 10
    And y is equal to 3
    When we subtract y from x
    Then the result should be 7

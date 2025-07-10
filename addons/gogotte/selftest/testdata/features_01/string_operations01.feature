Feature: String Operations
  As a user
  I want to manipulate strings
  So that I can perform basic string operations

  @string @concatenation
  Scenario: String Concatenation
    Given string1 is "Hello"
    And string2 is "World"
    When we concatenate string1 and string2
    Then the result should be "HelloWorld"

  @string @length
  Scenario: String Length
    Given string1 is "Testing"
    When we get the length of string1
    Then the result should be 7

@skip
Feature: Skip me

    Rule: Addition should work
        Scenario: Addition
            Given x is equal to 3
            When we add 4 to x
            Then x should be 7

        Scenario Outline: Outline Addition
            When we add the numbers <a> and <b>
            Then we should get <c>

        Examples:
            | a  | b  | c  |
            | 2  | 2  | 4  |
            | 10 | 20 | 30 |
            | 22 | 2  | 24 |

    Rule: Subtraction should work
        Scenario: Subtraction
            Given x is equal to 10
            When we subtract 2 from x
            Then x should be 8

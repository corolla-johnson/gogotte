@bartag
Feature: Calculator

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
        @footag
        Scenario: Subtraction
            Given x is equal to 10
            When we subtract 2 from x
            Then x should be 8

        Scenario: Datatable
            Given we initialize the variables to these
                | x  | y  | z  |
                | 10 | 11 | 12 |
            When we subtract 2 from x
            Then x should be 8

        Scenario: Docstring
            Given x is the following value
            """
                7
            """
            When we subtract 2 from x
            Then x should be 5

    Rule: This scenario should fail
        Scenario: Always fails
            Given a step that always fails

    Rule: This scenario should not be compiled or executed
        @skip
        Scenario: Skip me
            Given x is equal to 10
            When we subtract 2 from x
            Then x should be 8
extends GutTest

func test_gherkin_to_re_pattern_ideal() -> void:
    var g: String = "we have {arg1}, '{arg2}' and !{arg3}"
    var r: String = "we have (.+), '(.+)' and !(.+)"
    var result: String = StepDef.gherkin_to_re_pattern(g)
    assert_eq(result, r, "Basic placeholder replacement failed")

func test_gherkin_to_re_pattern_with_regex_chars() -> void:
    var g: String = "I have [item] with (priority) and {count} of them"
    var r: String = "I have \\[item\\] with \\(priority\\) and (.+) of them"
    var result: String = StepDef.gherkin_to_re_pattern(g)
    assert_eq(result, r, "Regex special character escaping failed")

func test_gherkin_to_re_pattern_multiple_placeholders() -> void:
    var g: String = "User {name} has {score} points and {level} level"
    var r: String = "User (.+) has (.+) points and (.+) level"
    var result: String = StepDef.gherkin_to_re_pattern(g)
    assert_eq(result, r, "Multiple placeholders replacement failed")

func test_gherkin_to_re_pattern_adjacent_placeholders() -> void:
    var g: String = "Transfer {amount} {currency} from {source}"
    var r: String = "Transfer (.+) (.+) from (.+)"
    var result: String = StepDef.gherkin_to_re_pattern(g)
    assert_eq(result, r, "Adjacent placeholders replacement failed")

func test_gherkin_already_anonymous_placeholders() -> void:
    var g: String = "Transfer {} {} from {}"
    var r: String = "Transfer (.+) (.+) from (.+)"
    var result: String = StepDef.gherkin_to_re_pattern(g)
    assert_eq(result, r, "Already anonymous placeholders replacement failed")

func test_anonymize_placeholders() -> void:
    var test_cases: Array[Array] = [
        ["I have {count} apples", "I have {} apples"],
        ["User {name} has {score} points", "User {} has {} points"],
        ["Transfer {amount}{currency} from {source}", "Transfer {}{} from {}"],
        ["No placeholders here", "No placeholders here"],
        ["Multiple {placeholders} in {one} {pattern}", "Multiple {} in {} {}"]
    ]

    for test_case: Array in test_cases:
        var input: String = test_case[0]
        var expected: String = test_case[1]
        var result: String = StepDef.anonymize_placeholders(input)
        assert_eq(result, expected, "Failed for input: " + input)

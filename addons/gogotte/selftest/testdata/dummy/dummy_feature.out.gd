extends GogotteTest

# This contains the full AST of the Gherkin feature.
var FEATURE_AST: Dictionary = {"_gogotte_metadata":{"feature_path":"res://addons/gogotte/selftest/testdata/dummy/dummy_feature.feature","filename":"dummy_feature.feature"},"feature":{"children":[{"scenario":{"keyword":"Scenario","name":"First Scenario","steps":[{"keyword":"Given ","keywordType":"Context","text":"I do something"}]}},{"scenario":{"keyword":"Scenario","name":"Second Scenario","steps":[{"keyword":"When ","keywordType":"Action","text":"I do something else"}]}},{"scenario":{"examples":[{"keyword":"Examples","tableBody":[{"cells":[{"value":"2"},{"value":"2"},{"value":"4"}]},{"cells":[{"value":"10"},{"value":"20"},{"value":"30"}]},{"cells":[{"value":"22"},{"value":"2"},{"value":"24"}]}],"tableHeader":{"cells":[{"value":"a"},{"value":"b"},{"value":"c"}]}}],"keyword":"Scenario Outline","name":"Third Scenario","steps":[{"keyword":"Given ","keywordType":"Context","text":"<a> is to <b> as <b> is to <c>"}]}}],"description":"This is a test feature","name":"Test Feature"}}

# These always begin with test_scenario_x followed by the scenario's name if available.
# The index disambiguates them if they have no name.
func test_scenario_0_first_scenario() -> void:
    _begin(0, -1)
    _step("Given ", "I do something", null, null)
    _end(0)

func test_scenario_1_second_scenario() -> void:
    _begin(1, -1)
    _step("When ", "I do something else", null, null)
    _end(1)

func test_scenario_2_third_scenario_0() -> void:
    _begin(2, 0)
    _step("Given ", "2 is to 2 as 2 is to 4", null, null)
    _end(2)

func test_scenario_2_third_scenario_1() -> void:
    _begin(2, 1)
    _step("Given ", "10 is to 20 as 20 is to 30", null, null)
    _end(2)

func test_scenario_2_third_scenario_2() -> void:
    _begin(2, 2)
    _step("Given ", "22 is to 2 as 2 is to 24", null, null)
    _end(2)


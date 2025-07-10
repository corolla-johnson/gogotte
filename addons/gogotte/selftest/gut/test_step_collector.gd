## Tests functions in StepCollector.
extends GutTest

func test_collect_dir_returns_all_steps() -> void:
    var sc: StepCollector = StepCollector.new(gut)

    var steps: Dictionary = sc.collect_dir("res://addons/gogotte/selftest/testdata/steps_01/")
    gut.p(steps.keys())
    assert_eq(len(steps), 6, "Number of steps should be correct")

func test_collect_returns_all_steps() -> void:
    var sc: StepCollector = StepCollector.new(gut)

    var steps: Array[StepDef] = sc.collect([
        "res://addons/gogotte/selftest/testdata/steps_01/",
        "res://addons/gogotte/selftest/testdata/steps_02/"
        ])
    gut.p(str(steps))
    assert_eq(len(steps), 9, "Number of steps should be correct")


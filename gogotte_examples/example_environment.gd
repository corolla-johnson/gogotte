extends GogotteEnvironment

## Called before each step.
func before_step(t: GogotteTest, _step: String) -> void:
    t.gut.p("before_step", 2)

## Called after each step.
func after_step(t: GogotteTest, _step: String) -> void:
    t.gut.p("after_step", 2)

## Called before each scenario.
func before_scenario(t: GogotteTest, _scenario: Dictionary) -> void:
    t.gut.p("before_scenario", 2)

## Called after each scenario.
func after_scenario(t: GogotteTest, _scenario: Dictionary) -> void:
    t.gut.p("after_scenario", 2)

## Called before each feature.
func before_feature(t: GogotteTest, _feature: Dictionary) -> void:
    t.gut.p("before_feature", 2)

## Called after each feature.
func after_feature(t: GogotteTest, _feature: Dictionary) -> void:
    t.gut.p("after_feature", 2)

## Called before a tagged section.
func before_tag(t: GogotteTest, _tag: String) -> void:
    t.gut.p("before_tag", 2)

## Called after a tagged section.
func after_tag(t: GogotteTest, _tag: String) -> void:
    t.gut.p("after_tag", 2)

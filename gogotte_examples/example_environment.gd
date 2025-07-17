extends GogotteEnvironment

## Called before each step.
func before_step(t: GogotteTest, _step: Dictionary) -> void:
    t.gut.p("This is called before a step")

## Called after each step.
func after_step(t: GogotteTest, _step: Dictionary) -> void:
    t.gut.p("This is called after a step")

## Called before each scenario.
func before_scenario(t: GogotteTest, _scenario: Dictionary) -> void:
    t.gut.p("This is called before a scenario")

## Called after each scenario.
func after_scenario(t: GogotteTest, _scenario: Dictionary) -> void:
    t.gut.p("This is called after a scenario")

## Called before each feature.
func before_feature(t: GogotteTest, _feature: Dictionary) -> void:
    t.gut.p("This is called before a feature")

## Called after each feature.
func after_feature(t: GogotteTest, _feature: Dictionary) -> void:
    t.gut.p("This is called after a feature")

## Called before a tagged section.
func before_tag(t: GogotteTest, _tag: String) -> void:
    t.gut.p("This is called before a tag")

## Called after a tagged section.
func after_tag(t: GogotteTest, _tag: String) -> void:
    t.gut.p("This is called after a tag")

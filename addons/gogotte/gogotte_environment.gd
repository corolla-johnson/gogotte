## Holds virtual functions that are called during the test lifecycle.
class_name GogotteEnvironment

static var _instance: GogotteEnvironment = null

## Called before each step.
func before_step(t: GogotteTest, step: Dictionary) -> void:
    pass

static func exec_before_step(t: GogotteTest, step: Dictionary) -> void:
    if _instance != null:
        _instance.before_step(t, step)

## Called after each step.
func after_step(t: GogotteTest, step: Dictionary) -> void:
    pass

static func exec_after_step(t: GogotteTest, step: Dictionary) -> void:
    if _instance != null:
        _instance.after_step(t, step)

## Called before each scenario.
func before_scenario(t: GogotteTest, scenario: Dictionary) -> void:
    pass

static func exec_before_scenario(t: GogotteTest, step: Dictionary) -> void:
    if _instance != null:
        _instance.before_scenario(t, step)

## Called after each scenario.
func after_scenario(t: GogotteTest, scenario: Dictionary) -> void:
    pass

static func exec_after_scenario(t: GogotteTest, step: Dictionary) -> void:
    if _instance != null:
        _instance.after_scenario(t, step)

## Called before each feature.
func before_feature(t: GogotteTest, feature: Dictionary) -> void:
    pass

static func exec_before_feature(t: GogotteTest, feature: Dictionary) -> void:
    if _instance != null:
        _instance.before_feature(t, feature)

## Called after each feature.
func after_feature(t: GogotteTest, feature: Dictionary) -> void:
    pass

static func exec_after_feature(t: GogotteTest, feature: Dictionary) -> void:
    if _instance != null:
        _instance.after_feature(t, feature)

## Called before a tagged section.
func before_tag(t: GogotteTest, tag: String) -> void:
    pass

static func exec_before_tag(t: GogotteTest, tag: String) -> void:
    if _instance != null:
        _instance.before_tag(t, tag)

## Called after a tagged section.
func after_tag(t: GogotteTest, tag: String) -> void:
    pass

static func exec_after_tag(t: GogotteTest, tag: String) -> void:
    if _instance != null:
        _instance.after_tag(t, tag)

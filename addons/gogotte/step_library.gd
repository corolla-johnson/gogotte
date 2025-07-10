## Class providing a global step library.
class_name StepLibrary

static var _stepdefs: Array[StepDef] = []

static func clear() -> void:
    _stepdefs.clear()

## Sets the stepdefs array.
static func set_stepdefs(stepdefs: Array[StepDef]) -> void:
    _stepdefs = stepdefs

## Tries to match a step to the string.
## Returns StepDef followed by the array of arguments.
static func match_step(step_str: String) -> Variant:
    for stepdef: StepDef in _stepdefs:
        var rem: RegExMatch = stepdef.regex.search(step_str)
        if rem:
            var retval: Array = [stepdef]
            retval.append_array(rem.strings.slice(1))
            return retval

    return null
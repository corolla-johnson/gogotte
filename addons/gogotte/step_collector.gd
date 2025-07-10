## Class that collects StepDefs from the given directories.
## A StepDef (step definition) is the executable 'meaning' of a Gherkin line.
class_name StepCollector

var gut: GutMain = null

func _init(gut: GutMain) -> void:
    self.gut = gut

## Collects StepDef from a list of directories and returns them in a single array.
func collect(dirs: Array) -> Array[StepDef]:
    var steps: Dictionary = {}
    var step_defs: Array[StepDef] = []

    for dir: String in dirs:
        var dir_steps: Dictionary = collect_dir(dir)
        for pattern in dir_steps.keys():
            assert(
                pattern not in steps.keys(),
                str("[Gogotte]: Ambiguous step pattern ", pattern))
            step_defs.append(dir_steps[pattern])

    gut.p(str("[Gogotte]: Collected ", len(step_defs), " steps"), 2)

    return step_defs

## Collects steps from a single directory and returns a dictionary.
func collect_dir(dir: String) -> Dictionary:
    var dir_access: DirAccess = DirAccess.open(dir)

    # Browse to directory
    if not dir_access:
        gut.p(str('Failed to open step directory ', dir))
        return {}

    var dir_steps: Dictionary = {}

    for filename: String in dir_access.get_files():
        # Validate filename
        if not filename.ends_with('steps.gd'):
            continue

        var path: String = str(dir, filename)

        # Load script
        var script: Script = load(path)
        assert(script != null, str('[Gogotte]: Failed to load step script ', path))

        # Make sure script has a Dictionary called 'steps'
        var script_inst: Object = script.new()
        var script_steps: Dictionary = script_inst.get("steps") as Dictionary
        assert(script_steps != null,
                str('[Gogotte]: Script ', str(script_inst),
                    ' did not have a steps Dictionary'))

        # Validate each step in the script
        for pattern: Variant in script_steps.keys():
            var value: Variant = script_steps[pattern]

            assert(
                pattern is String,
                str("[Gogotte]: Expected pattern to be String, got ",
                    str(pattern), " (", path, ")"))

            assert(
                script_steps[pattern] is Callable,
                str("[Gogotte]: Expected value to be Callable, got ",
                    str(value), " (", path, ")"))

            # A limitation of Gogotte is that placeholder names are not respected,
            # hence we must anonymize
            var dict_key: String = StepDef.anonymize_placeholders(pattern)

            # Check for ambiguous step patterns
            assert(
                dict_key not in dir_steps.keys(),
                str("[Gogotte]: Ambiguous step pattern ", pattern))

            var step_def: StepDef = StepDef.new(pattern, value)

            gut.p(str("[Gogotte]: Collected step \'", pattern, "\'"), 2)
            gut.p(str("[Gogotte]: Re: \'", step_def.regex.get_pattern(), "\'"), 2)

            dir_steps[dict_key] = step_def

    return dir_steps
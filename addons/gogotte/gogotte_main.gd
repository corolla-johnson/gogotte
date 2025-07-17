## GogotteMain acts as the entrypoint to Gogotte compilation.
## It calls most of the steps discussed in arch_proposal.md.
class_name GogotteMain

var _gut: GutMain

func _init(gut: GutMain) -> void:
    _gut = gut

## Runs Gogotte for the project.
## Turns .feature files in the configured directories
## into GUT tests and outputs them to res://addons/gogotte/_out/
func run(config_path: String = "res://.gogotteConfig") -> void:

    # Step 3. Retrieve .gogotteConfig
    var config: Dictionary = _get_config(config_path)
    _gut.p("[Gogotte]: Config retrieved successfully", 2)

    # Load environment script
    var env_path = config.get('environment', null)
    if env_path != null:
        GogotteEnvironment.load_environment_script(load(env_path) as Script)
        _gut.p(str("[Gogotte]: Loaded environment script from ", env_path), 2)

    # Get gut directories
    var feature_dirs: Array = _gut.add_children_to.gut_config.options.dirs
    _gut.p(str("[Gogotte]: Gut directories: ", _gut.add_children_to.gut_config.options.dirs), 2)

    # Step 4. Collect features
    var feature_collector: FeatureCollector = FeatureCollector.new(_gut)
    var features: Array[Dictionary] = feature_collector.collect(feature_dirs)
    _gut.p(str("[Gogotte]: Collected ", features.size(), " feature(s)"), 1)

    # Step 5. Collect steps
    var step_collector: StepCollector = StepCollector.new(_gut)
    var steps = step_collector.collect(config['step_dirs'])
    _gut.p(str("[Gogotte]: Collected ", steps.size(), " step definition(s)"), 1)

    # Step 6. Set steps globally
    StepLibrary.set_stepdefs(steps)
    _gut.p("[Gogotte]: Steps set globally", 2)

    # Step 7. Compile features into GUT scripts
    var compiler: GogotteCompiler = GogotteCompiler.new(_gut)
    compiler.compile(features, config.get('save_ast', false))
    _gut.p("[Gogotte]: Features compiled successfully", 1)

    # Step 8. Load compiled scripts into Gut
    for feature: Dictionary in features:
        _gut.add_script(feature._gogotte_metadata.script_path)
    _gut.p("[Gogotte]: Added compiled scripts to Gut", 1)

## Retrieves the configuration variables.
func _get_config(config_path: String) -> Dictionary:
    var config_file: FileAccess = FileAccess.open(config_path, FileAccess.READ)
    assert(
        config_file != null,
        str("[Gogotte]: Could not open config file at ", config_path))

    var config: Dictionary = JSON.parse_string(config_file.get_as_text())
    assert(
        config != null,
        str("[Gogotte]: Config file has malformed JSON at ", config_path))

    assert(
        config.get("step_dirs") != null,
        str("[Gogotte]: Config file has no 'step_dirs' item"))

    return config

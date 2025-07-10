## Class that collects Gherkin feature files from the given directories.
class_name FeatureCollector

var gut: GutMain = null

func _init(gut: GutMain) -> void:
    self.gut = gut

## Collects features from a list of directories.
## Returns an array of AST dictionaries.
func collect(dirs: Array) -> Array[Dictionary]:
    var features: Array[Dictionary] = []

    for dir in dirs:
        var dir_features = collect_dir(dir)
        features.append_array(dir_features)

    return features

## Converts relative res:// path to an absolute path.
func _get_path_absolute(path: String) -> Variant:
    var file: FileAccess = FileAccess.open(path, FileAccess.READ)

    assert(
        file != null,
        str("[Gogotte]: Failed to access file at ", path)
    )

    var abs_path: String = file.get_path_absolute()
    file.close()
    return abs_path

## Collects features from a single directory.
## Returns an array of AST dictionaries.
func collect_dir(dir: String) -> Array[Dictionary]:
    var dir_access: DirAccess = DirAccess.open(dir)
    var features: Array[Dictionary] = []

    # Check if directory exists
    if not dir_access:
        gut.p(str("[Gogotte]: Failed to open feature directory ", dir))
        return features

    # Process all .feature files in the directory
    for filename in dir_access.get_files():
        if not filename.ends_with(".feature"):
            continue

        var feature_path = dir.path_join(filename)
        var feature_abs_path: String = _get_path_absolute(feature_path)

        # We will use Python to call the official Gherkin parser.
        var parser_path: String = _get_path_absolute("res://addons/gogotte/parse_feature.py")

        var output: Array = []
        var res: int = OS.execute("python", [parser_path, feature_abs_path], output, true)
        var stdout: String = output[0]
        var stderr: String = output[1] if len(output) > 1 else ""
        assert(
            res == 0,
            str("[Gogotte]: Failed to parse feature ", filename, ", 'python parse_feature.py' exited w/ status: ",
                res, "\nstdout:\n", stdout, "\nstderr:\n", stderr))
        var document: Variant = JSON.parse_string(output[0])

        assert(
            document != null,
            str("[Gogotte]: Failed to parse JSON from file ", feature_path))

        # Inject the original feature filename into the AST
        # so that each compiled GUT test can be given the same filename
        # as its original .feature.
        var feature_dict = document as Dictionary
        feature_dict["_gogotte_metadata"] = {
            "filename": filename,
            "feature_path": feature_path
        }

        # If the feature has the 'skip' tag we can skip collection.
        var skip = false
        for tag in feature_dict.feature.get("tags", []):
            if tag.name == "@skip":
                skip = true
                break
        if skip:
            gut.p(str("[Gogotte]: Skipping feature at ", feature_path), 2)
            continue

        features.append(feature_dict)
        gut.p(str("[Gogotte]: Collected feature file ", feature_path), 2)

    # Process subdirectories recursively
    for subdir in dir_access.get_directories():
        if subdir == "." or subdir == "..":
            continue

        var subdir_path = dir.path_join(subdir)
        var subdir_features = collect_dir(subdir_path)
        features.append_array(subdir_features)

    return features

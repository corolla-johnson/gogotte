## Tests functions in FeatureCollector.
extends GutTest

func test_collect_single_directory() -> void:
    var fc: FeatureCollector = FeatureCollector.new(gut)

    var features: Array[Dictionary] = fc.collect_dir("res://addons/gogotte/selftest/testdata/features_01/")
    assert_eq(len(features), 2, "Wrong number of features collected")

func test_collect_recursively() -> void:
    var fc: FeatureCollector = FeatureCollector.new(gut)

    var features: Array[Dictionary] = fc.collect_dir("res://addons/gogotte/selftest/testdata/features_02/")
    assert_eq(len(features), 2, "Wrong number of features collected")

func test_collect_multiple_directories() -> void:
    var fc: FeatureCollector = FeatureCollector.new(gut)

    var features: Array[Dictionary] = fc.collect(
        ["res://addons/gogotte/selftest/testdata/features_01/", "res://addons/gogotte/selftest/testdata/features_02/"])
    assert_eq(len(features), 4, "Wrong number of features collected")
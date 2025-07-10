extends GutTest

var _compiler: GogotteCompiler
var _dummy_feature: Dictionary

func before_each() -> void:
    _compiler = GogotteCompiler.new(gut)

    # Create a simple test feature AST
    _dummy_feature = {
        "feature": {
            "name": "Test Feature",
            "description": "This is a test feature",
            "children": [
                {
                    "scenario": {
                        "name": "First Scenario",
                        "keyword": "Scenario",
                        "steps": [
                            {
                                "keyword": "Given ",
                                "keywordType": "Context",
                                "text": "I do something"
                            }
                        ]
                    }
                },
                {
                    "scenario": {
                        "name": "Second Scenario",
                        "keyword": "Scenario",
                        "steps": [
                            {
                                "keyword": "When ",
                                "keywordType": "Action",
                                "text": "I do something else"
                            }
                        ]
                    }
                },
                {
                    "scenario": {
                        "name": "Third Scenario",
                        "keyword": "Scenario Outline",
                        "steps": [
                            {
                                "keyword": "Given ",
                                "keywordType": "Context",
                                "text": "<a> is to <b> as <b> is to <c>"
                            }
                        ],
                        "examples": [
                            {
                                "keyword": "Examples",
                                "tableBody": [
                                    {
                                        "cells": [
                                            {
                                                "value": "2"
                                            },
                                            {
                                                "value": "2"
                                            },
                                            {
                                                "value": "4"
                                            }
                                        ],
                                    },
                                    {
                                        "cells": [
                                            {
                                                "value": "10"
                                            },
                                            {
                                                "value": "20"
                                            },
                                            {
                                                "value": "30"
                                            }
                                        ],
                                    },
                                    {
                                        "cells": [
                                            {
                                                "value": "22"
                                            },
                                            {
                                                "value": "2"
                                            },
                                            {
                                                "value": "24"
                                            }
                                        ]
                                    }
                                ],
                                "tableHeader": {
                                    "cells": [
                                        {
                                            "value": "a"
                                        },
                                        {
                                            "value": "b"
                                        },
                                        {
                                            "value": "c"
                                        }
                                    ]
                                },
                            }
                        ]
                    }
                }
            ]
        },
        "_gogotte_metadata": {
            "filename": "dummy_feature.feature",
            "feature_path": "res://addons/gogotte/selftest/testdata/dummy/dummy_feature.feature"
        }
    }

func test_extract_scenarios() -> void:
    var scenarios: Array = _compiler._extract_scenarios(_dummy_feature)
    assert_eq(scenarios.size(), 3, "Should extract 2 scenarios")
    assert_eq(scenarios[0].name, "First Scenario", "First scenario should have correct name")
    assert_eq(scenarios[1].name, "Second Scenario", "Second scenario should have correct name")

func test_sanitize_filename() -> void:
    assert_eq(_compiler._sanitize_filename("Test Feature"), "test_feature", "Should sanitize feature name")
    assert_eq(_compiler._sanitize_filename("Test-Feature!"), "testfeature", "Should remove special characters")
    assert_eq(_compiler._sanitize_filename("Test Feature 123"), "test_feature_123", "Should handle numbers")

func test_sanitize_method_name() -> void:
    assert_eq(_compiler._sanitize_method_name("First Scenario"), "first_scenario", "Should sanitize scenario name")
    assert_eq(_compiler._sanitize_method_name("First-Scenario!"), "firstscenario", "Should remove special characters")
    assert_eq(_compiler._sanitize_method_name("First Scenario 123"), "first_scenario_123", "Should handle numbers")

func test_generate_script() -> void:
    var script: String = _compiler._generate_script(_dummy_feature)

    # Check that the script extends GogotteTest
    assert_string_contains(script, "extends GogotteTest", "Script should extend GogotteTest")

    # Check that the script contains the feature AST
    assert_string_contains(script, "var FEATURE_AST: Dictionary =", "Script should contain feature AST")

    # Check that the script contains test methods for each scenario
    assert_string_contains(script, "func test_scenario_0_first_scenario() -> void:", "Script should contain test method for first scenario")
    assert_string_contains(script, "func test_scenario_1_second_scenario() -> void:", "Script should contain test method for second scenario")

    # Check that the script processes scenario outline correctly
    assert_string_contains(script, "func test_scenario_2_third_scenario_0() -> void:", "Script should contain three versions of third scenario")
    assert_string_contains(script, "func test_scenario_2_third_scenario_1() -> void:", "Script should contain three versions of third scenario")
    assert_string_contains(script, "func test_scenario_2_third_scenario_2() -> void:", "Script should contain three versions of third scenario")

    assert_string_contains(script, "_begin(0, -1)", "Script should begin 1st scenario")
    assert_string_contains(script, "_begin(1, -1)", "Script should begin 2nd scenario")
    assert_string_contains(script, "_begin(2, 0)", "Script should begin 3rd scenario")
    assert_string_contains(script, "_begin(2, 1)", "Script should begin 3rd scenario")
    assert_string_contains(script, "_begin(2, 2)", "Script should begin 3rd scenario")

    assert_string_contains(script, "_end(0)", "Script should begin 1st scenario")
    assert_string_contains(script, "_end(1)", "Script should begin 2nd scenario")

    # Check that the test methods create step calls
    assert_string_contains(script, "_step(\"Given \", \"I do something\", null, null)", "Script should contain steps for first scenario")
    assert_string_contains(script, "_step(\"When \", \"I do something else\", null, null)", "Script should contain steps for second scenario")

    # Check scenario outline works
    assert_string_contains(script, "_step(\"Given \", \"2 is to 2 as 2 is to 4\", null, null)", "Script should contain steps for scenario outline")
    assert_string_contains(script, "_step(\"Given \", \"10 is to 20 as 20 is to 30\", null, null)", "Script should contain steps for scenario outline")
    assert_string_contains(script, "_step(\"Given \", \"22 is to 2 as 2 is to 24\", null, null)", "Script should contain steps for scenario outline")

func test_compile() -> void:
    # Call compile with our test feature
    _compiler.compile([_dummy_feature])

    # Check if files were created in the _out directory
    var feature_path: String = _dummy_feature._gogotte_metadata.feature_path.get_base_dir()
    var dir: DirAccess = DirAccess.open(feature_path)
    assert_not_null(dir, "Should be able to open _out directory")

    # Get all .gd files in the directory
    var gd_files: Array[String] = []
    dir.list_dir_begin()
    var file_name: String = dir.get_next()
    while file_name != "":
        if file_name.ends_with(".out.gd"):
            gd_files.append(file_name)
        file_name = dir.get_next()
    dir.list_dir_end()

    # Verify that at least one .gd file was created
    assert_true(gd_files.size() == 1, "A .out.gd file should be created")

    # Find the file that matches our test feature
    var test_file: String = ""
    for file: String in gd_files:
        if file.begins_with("dummy_feature"):
            test_file = file
            break
    assert_ne(test_file, "", "Should find a file matching our test feature")

    # Read the content of the file
    var file_path: String = feature_path.path_join(test_file)
    var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
    assert_not_null(file, "Should be able to open the generated file")

    var content: String = file.get_as_text()
    file.close()

    # Verify the content
    assert_string_contains(content, "extends GogotteTest", "Generated file should extend GogotteTest")
    assert_string_contains(content, "var FEATURE_AST: Dictionary =", "Generated file should contain feature AST")
    assert_string_contains(content, "func test_scenario_0_first_scenario() -> void:", "Generated file should contain test method for first scenario")
    assert_string_contains(content, "func test_scenario_1_second_scenario() -> void:", "Generated file should contain test method for second scenario")

    pass_test("Compile should generate and write scripts correctly")

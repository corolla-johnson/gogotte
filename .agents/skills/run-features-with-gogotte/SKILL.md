---
name: run-features-with-gogotte
description: Run features using Gogotte, a Gherkin-language compiler for Godot and GUT (Godot Unit Test)
compatibility: Windows; requires ability to start godot from console
---

## Background
- This project uses the Gogotte addon to add TDD capability to the GUT (Godot Unit Test) addon.
- Gogotte is triggered by the pre-run hook feature of GUT.
- Gogotte turns `.feature` files into `.out.gd` files, which GUT then executes.
    - .out.gd files should never be modified manually.

## Instructions
- You would generally run tests after making changes to the codebase.

- Run a PS command as below:

```Godot_v4.7-stable_win64.exe -d -s addons/gut/gut_cmdln.gd -gpre_run_script res://addons/gogotte/gogotte_hook_script.gd -gdir <dirs> -gexit```

- ...replacing `<dirs>` with at least one feature directory beginning with `res://`.

- The above command uses the godot executable to run the `gut_cmdln.gd` script over the feature directories that you are interested in, adding `gogotte_hook_script.gd` as the pre-run hook.

- It's possible that Godot will crash on exit with signal 11. Ignore this and instead see if the relevant feature(s) have passed or failed.

## Troubleshooting
- The above example assumes that the Godot executable is in PATH.
- If not, or this throws something related to the keyword being unrecognized, please ask user. This should be set up using PATH
- `.gogotteConfig` should exist and be configured correctly.
    - "step_dirs" should point to at least one directory containing step files, which will likely end in `_steps.gd.`
    - "environment" should point to a Gherkin environment script. Usually there is only one for the whole project.

## Links
- Gogotte documentation: https://github.com/corolla-johnson/gogotte
- GUT documentation: https://gut.readthedocs.io/en/v9.7.0/index.html
    - Specifically: https://gut.readthedocs.io/en/v9.7.0/Command-Line.html
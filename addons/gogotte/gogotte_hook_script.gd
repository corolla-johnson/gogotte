class_name GogotteHookScript
extends GutHookScript

## Just create an instance of GogotteMain and run().
## This is intended to be overridable.
func run():
    gut.p("Gogotte Hook is running")
    var gogotte: GogotteMain = GogotteMain.new(gut)
    gogotte.run()
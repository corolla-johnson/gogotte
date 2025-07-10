class_name ExampleSteps

var steps: Dictionary = {

    "x is equal to {number}":
    func (t: GogotteTest, number: String) -> void:
        t.ctx.x = int(number),

    "we add {number} to x":
    func (t: GogotteTest, number: String) -> void:
        t.ctx.x = t.ctx.x + int(number),

    "we subtract {number} from x":
    func (t: GogotteTest, number: String) -> void:
        t.ctx.x = t.ctx.x - int(number),

    "we initialize the variables to these":
    func (t: GogotteTest) -> void:
        var variables: Array = t.datatable[0]
        var values: Array = t.datatable[1]
        for i in range(len(variables)):
            t.ctx[variables[i]] = int(values[i]),

    "x is the following value":
    func (t: GogotteTest) -> void:
        t.ctx.x = int(t.docstring),

    "x should be {number}":
    func (t: GogotteTest, number: String) -> void:
        t.assert_eq(t.ctx.x, int(number), "x was not correct")
        t.gut.p("OK"),

    "a step that always fails":
    func (t: GogotteTest) -> void:
        t.assert_true(false, "This assertion always fails"),

    "we add the numbers {a} and {b}":
    func (t: GogotteTest, a: String, b: String) -> void:
        t.ctx.res = int(a) + int(b),

    "we should get {res}":
    func (t: GogotteTest, res: String) -> void:
        t.assert_eq(t.ctx.res, int(res), "Result was not correct")
}
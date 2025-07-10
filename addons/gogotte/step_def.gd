## Class representing a step definition.
class_name StepDef

## Gherkin pattern for this step.
var g_pattern: String

## Callable for this step.
var callable: Callable

## Regex for this step.
var regex: RegEx

func _init(pattern: String, callable: Callable) -> void:
    self.g_pattern = pattern
    self.callable = callable
    self.regex = RegEx.create_from_string(gherkin_to_re_pattern(pattern))

    # Validate the callable.
    # We must have the same number of placeholders as free arguments.
    var arg_count: int = callable.get_argument_count()
    var group_count: int = regex.get_group_count()
    assert(
        arg_count == group_count + 1,
        str("[Gogotte]: Callable for pattern ", g_pattern, " should have ",
            group_count, " + 1 args, but had ", arg_count)
    )

func _to_string():
    return str("<StepDef(\"", self.g_pattern, "\")>")

## Converts a Gherkin pattern into a Regex pattern.
static func gherkin_to_re_pattern(pattern: String) -> String:
    # Escape regex special characters
    var escaped_pattern = pattern

    # Escape parentheses, brackets, and other regex special chars
    escaped_pattern = escaped_pattern.replace('\\', '\\\\')
    escaped_pattern = escaped_pattern.replace('(', '\\(')
    escaped_pattern = escaped_pattern.replace(')', '\\)')
    escaped_pattern = escaped_pattern.replace('[', '\\[')
    escaped_pattern = escaped_pattern.replace(']', '\\]')
    escaped_pattern = escaped_pattern.replace('.', '\\.')
    escaped_pattern = escaped_pattern.replace('+', '\\+')
    escaped_pattern = escaped_pattern.replace('*', '\\*')
    escaped_pattern = escaped_pattern.replace('?', '\\?')
    escaped_pattern = escaped_pattern.replace('^', '\\^')
    escaped_pattern = escaped_pattern.replace('$', '\\$')
    escaped_pattern = escaped_pattern.replace('|', '\\|')

    # Find all Gherkin placeholders and replace them with regex capturing groups
    var regex = RegEx.new()
    regex.compile("\\{([^}]*)\\}")

    var result = ""
    var last_end = 0

    var matches = regex.search_all(escaped_pattern)
    for m in matches:
        # Add text before the match
        result += escaped_pattern.substr(last_end, m.get_start() - last_end)
        # Add the capturing group
        result += "(.+)"
        # Update last_end
        last_end = m.get_end()

    # Add any remaining text
    if last_end < escaped_pattern.length():
        result += escaped_pattern.substr(last_end)

    return result

## Preprocesses a Gherkin pattern by removing the content inside curly braces.
## Useful for ambiguous step checking.
## Example: "I have {count} apples" -> "I have {} apples"
static func anonymize_placeholders(pattern: String) -> String:
    var regex = RegEx.new()
    regex.compile("\\{[^}]+\\}")

    var result = ""
    var last_end = 0

    var matches = regex.search_all(pattern)
    for m in matches:
        # Add text before the match
        result += pattern.substr(last_end, m.get_start() - last_end)
        # Add empty curly braces
        result += "{}"
        # Update last_end
        last_end = m.get_end()

    # Add any remaining text
    if last_end < pattern.length():
        result += pattern.substr(last_end)

    return result

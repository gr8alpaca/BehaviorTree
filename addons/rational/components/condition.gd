@icon("../icons/Conditional.svg")
@tool
class_name ConditionLeaf extends Leaf

const EXPRESSION_PLACEHOLDER: String = "Enter condition..."

@export_multiline 
var condition: String: set = set_condition

var expression: Expression


func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS if expression.execute([], board) else FAILURE


func set_condition(val: String) -> void:
	condition = val

	if not condition:
		condition = EXPRESSION_PLACEHOLDER

	expression = parse_expression(condition)
	changed.emit()


func parse_expression(source: String) -> Expression:
	var result: Expression = Expression.new()
	var error: int = result.parse(source)

	if not Engine.is_editor_hint() and error != OK:
		push_error(
			(
				"<Condition:%s> Couldn't parse expression with source: `%s` Error text: `%s`"
				% [resource_name, source, result.get_error_text()]
			)
		)

	return result


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(["Expression invalid"]) if expression.get_error_text() else PackedStringArray()

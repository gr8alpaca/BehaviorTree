@tool
@icon("../icons/Conditional.svg")
class_name ConditionLeaf extends Leaf

## Expression that will return [code]SUCCESS[/code] if true
## and [code]FAILURE[/code] if false. Executes expression using [member RationalTree.actor]
## and a reference to the blackboard as variable: [code]board[/code].
@export_multiline var condition: String: set = set_condition

## Expression that is executed on [method tick] call. Defaults to 
## [code]false[/code] if parse fails.
var expression: Expression


func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS if expression.execute([board], actor, false) else FAILURE


func set_condition(val: String) -> void:
	condition = val
	expression = parse_expression(condition)
	changed.emit()


func parse_expression(source: String) -> Expression:
	var result: Expression = Expression.new()
	var error: int = result.parse(source, PackedStringArray(["board"]))

	if not Engine.is_editor_hint() and error != OK:
		push_error("<Condition> Couldn't parse expression with source: `%s` Error text: `%s`" % [source, result.get_error_text()])
		result.parse("false", PackedStringArray(["board"]))

	return result


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"ConditionLeaf")
	return names


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(["Expression invalid"]) if expression.get_error_text() else PackedStringArray()

@tool
class_name RationalComponent extends Resource

enum {SUCCESS, FAILURE, RUNNING}

func setup(actor: Node, board: Blackboard) -> void:
	pass


## Executes this node and returns a status code.
func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS


func get_children(recursive: bool = false) -> Array[RationalComponent]:
	return []


## Calls method on parents first then each child and so on
# func propagate_call(method: StringName, args: Array = []) -> void:
# 	if has_method(method): callv(method, args)

		
func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray()


func _set(property: StringName, value: Variant) -> bool:
	if Engine.is_editor_hint():

		match property:
			
			&"resource_path":
				resource_path = value
				changed.emit()

			&"resource_local_to_scene":
				resource_local_to_scene = true
				
	return false
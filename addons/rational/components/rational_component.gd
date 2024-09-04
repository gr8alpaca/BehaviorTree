@tool
@icon("../icons/RationalComponent.svg")
class_name RationalComponent extends Resource

enum {SUCCESS, FAILURE, RUNNING}


## Override this method to customize behavior when not receiving a tick...
func _no_tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE


## Override this method to customize tree behavior.
func _tick(delta: float, board: Blackboard, actor: Node) -> int:
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


## Do [b]not[/b] override this method, use [method _tick] instead.
func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS

## Do [b]not[/b] override this method, use [method _no_tick] instead.
func no_tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE

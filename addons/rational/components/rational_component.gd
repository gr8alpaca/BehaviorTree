@tool
@icon("../icons/RationalComponent.svg")
class_name RationalComponent extends Resource

enum {SUCCESS, FAILURE, RUNNING}


signal parent_changed(parent: RationalComponent)


## Root that this component extends from. If null it is assumed this resource is a tree/subtree.
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "RationalComponent", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
var parent: RationalComponent: set = set_root

func set_root(val: RationalComponent) -> void:
		parent = val
		parent_changed.emit(parent)


## Override this method to customize behavior when not receiving a tick...
func _no_tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE


## Override this method to customize tree behavior.
func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS


func get_children(recursive: bool = false) -> Array[RationalComponent]:
	return []

	
func get_class_name() -> Array[StringName]:
	return [&"RationalComponent"]


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray()


func _set(property: StringName, value: Variant) -> bool:
	if Engine.is_editor_hint():

		match property:
			&"resource_name":
				resource_name = value if value else get_class_name().back()
				changed.emit()

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

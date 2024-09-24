@tool
@icon("../icons/RationalComponent.svg")
class_name RationalComponent extends Resource

enum {SUCCESS, FAILURE, RUNNING}


signal parent_changed(parent: RationalComponent)


## Root that this component extends from. If null it is assumed this resource is a tree/subtree.
@export_custom(0, "", PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_NO_INSTANCE_STATE)
var parent: RationalComponent: set = set_parent

func set_parent(val: RationalComponent) -> void:
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
	match property:

		&"resource_name":
			resource_name = value if value else get_class_name().back()
			changed.emit()

		&"resource_path":
			resource_path = value
			changed.emit()

	return false


## Do [b]not[/b] override this method, use [method _tick] instead.
func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS

## Do [b]not[/b] override this method, use [method _no_tick] instead.
func no_tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE

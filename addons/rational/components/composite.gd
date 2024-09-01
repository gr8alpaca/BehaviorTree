@tool
class_name Composite extends RationalComponent

signal children_changed

@export
var children: Array[RationalComponent] = []: set = set_children


func set_children(val: Array[RationalComponent]) -> void:
	children = val
	children_changed.emit()
	notify_property_list_changed()

## Called 
func setup(actor: Node, board: Blackboard) -> void:
	for child: RationalComponent in children:
		child.setup(actor, board)


## Overwrite this function!
func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(["Children empty"]) if children.is_empty() else PackedStringArray()


func get_children(recursive: bool = false) -> Array[RationalComponent]:
	var all_children: Array[RationalComponent] = children.duplicate(false)
	if recursive:
		for child: RationalComponent in children:
			all_children += child.get_children(recursive)

	return all_children


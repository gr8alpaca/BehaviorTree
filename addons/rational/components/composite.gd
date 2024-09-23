@tool
class_name Composite extends RationalComponent


signal children_changed


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:RationalComponent", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE)
var children: Array[RationalComponent]: set = set_children


func set_children(val: Array[RationalComponent]) -> void:
	children = val

	for child: RationalComponent in children:
		if not child: continue
		child.parent =  self

	children_changed.emit()
	notify_property_list_changed()


func setup(actor: Node, board: Blackboard) -> void:
	for child: RationalComponent in children:
		child.setup(actor, board)


func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	return FAILURE


func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(["Children empty"]) if children.is_empty() else PackedStringArray()


func get_children(recursive: bool = false) -> Array[RationalComponent]:
	var all_children: Array[RationalComponent] = children.duplicate(false)
	if recursive:
		for child: RationalComponent in children:
			all_children += child.get_children(recursive)

	return all_children


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"Composite")
	return names


func _get_property_list() -> Array[Dictionary]:
	return [
			{
				name = &"add_child_by_script",
				type = TYPE_OBJECT,
				hint = PROPERTY_HINT_RESOURCE_TYPE,
				hint_string = "GDScript",
				usage = PROPERTY_USAGE_EDITOR,
			}
		]

func _set(property: StringName, value: Variant) -> bool:
	if Engine.is_editor_hint():
		if property == &"add_child_by_script" and value != null and value is GDScript:
			if value.can_instantiate():
				var instance: Object = value.new()
				if not instance is RationalComponent:
					push_error()
				print(value.get_instance_base_type())
				children += [value.new()]
	return false

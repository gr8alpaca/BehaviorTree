@tool
class_name Composite extends RationalComponent

signal children_changed


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:RationalComponent",
PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_ALWAYS_DUPLICATE)
var children: Array[RationalComponent] = []: set = set_children


func set_children(val: Array[RationalComponent]) -> void:
	children = val
	children_changed.emit()
	notify_property_list_changed()


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

func _get_property_list() -> Array[Dictionary]:
	return \
	[
		{
			name = &"child_script",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_FILE,
			hint_string = "*.gd",
			usage = PROPERTY_USAGE_EDITOR,
		}
	]

func _set(property: StringName, value: Variant) -> bool:
	if Engine.is_editor_hint():
		if property == &"child_script" and value and FileAccess.file_exists(value):
			
			var script: GDScript = load(value)
			if not script.can_instantiate():
				print("CANNOT INSTANTIATE SCRIPT!!!!")
				return false

			var script_obj: Variant = script.new()
			if not script_obj is RationalComponent:
				print("Error: %s script did not inherit from RationalComponent!" % self)

			else:
				print("WERLJSLDJ SETTING !!!!")
				children.append(script_obj as RationalComponent)
				children = children
				return true
				
	return false

func _get(property: StringName) -> Variant:
	if property == &"child_script": return ""
		
	return null
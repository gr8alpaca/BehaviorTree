@tool
@icon("../icons/Tree.svg")
class_name RationalTree extends Node

signal tree_enabled
signal tree_disabled

signal ticked(value: int)


enum {SUCCESS, FAILURE, RUNNING}


@export_storage var actor: Node

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Blackboard", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NEVER_DUPLICATE | PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT)
var blackboard: Blackboard = Blackboard.new(): set = set_blackboard

@export_custom(0, "", PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_INTERNAL | PROPERTY_USAGE_NEVER_DUPLICATE | PROPERTY_USAGE_EDITOR_INSTANTIATE_OBJECT)
var master_root: Decorator = Decorator.new():
	set(val): master_root = val if val else Decorator.new()

@export var disabled: bool = true: set = set_disabled


# TODO
@export var action_debug_label: bool


func _enter_tree() -> void:
	pass

	
func _ready() -> void:
	disabled = Engine.is_editor_hint()
	

func _process(delta: float) -> void:
	if can_tick():
		ticked.emit(master_root.tick(delta, blackboard, actor))
	

func can_tick() -> bool:
	return not disabled


## Propagates call to all tree components
func call_tree(method: StringName, args: Array = []) -> void:
	for child: RationalComponent in master_root.get_children(true):
		if child.has_method(method):
			child.callv(method, args)


func set_disabled(val: bool) -> void:
	disabled = val
	set_process(can_tick())
	if disabled:
		tree_disabled.emit()
	else:
		tree_enabled.emit()


func set_blackboard(val: Blackboard) -> void:
	blackboard = val if val else Blackboard.new()
	update_configuration_warnings()


func get_class_name() -> Array[StringName]:
	return [&"RationalTree"]


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()

	return warnings


func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary]
	props.push_back({
			name=&"root",
			type=TYPE_OBJECT,
			hint=PROPERTY_HINT_RESOURCE_TYPE,
			hint_string="Composite",
			usage=PROPERTY_USAGE_DEFAULT,
		})
	
	return props


func _set(property: StringName, value: Variant) -> bool:
	match property:
		&"root":
			master_root.set(&"child", value)
			# notify_property_list_changed()
			return true

	return false


func _get(property: StringName) -> Variant:
	match property:
		&"root":
			return master_root.get(&"child")
		_:
			return null


func _notification(what: int) -> void:

	match what:

		NOTIFICATION_PATH_RENAMED when has_user_signal(&"path_changed"):
			emit_signal(&"path_changed")


		NOTIFICATION_PARENTED when not actor:
			actor = get_parent()
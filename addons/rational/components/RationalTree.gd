@tool
@icon("../icons/Tree.svg")
class_name RationalTree extends Node

signal tree_enabled
signal tree_disabled

signal ticked(value: int)


enum {SUCCESS, FAILURE, RUNNING}


@export var actor: Node: set = set_actor


@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Blackboard", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NEVER_DUPLICATE)
var blackboard: Blackboard = Blackboard.new(): set = set_blackboard


@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Composite", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NO_INSTANCE_STATE)
var root: Composite: set = set_root


@export var disabled: bool = true: set = set_disabled


# TODO
@export var action_debug_label: bool


func _enter_tree() -> void:
	if not actor:
		actor = get_parent()

	
func _ready() -> void:
	disabled = Engine.is_editor_hint()
	

func _process(delta: float) -> void:
	if can_tick():
		ticked.emit(root.tick(delta, blackboard, actor))


func can_tick() -> bool:
	return not disabled and root


## Propagates call to all tree components
func call_tree(method: StringName, args: Array = []) -> void:
	for child: RationalComponent in root.get_children(true):
		if child.has_method(method):
			child.callv(method, args)


func set_disabled(val: bool) -> void:
	disabled = val
	set_process(can_tick())
	if disabled:
		tree_disabled.emit()
	else:
		tree_enabled.emit()


func set_actor(val: Node) -> void:
	actor = val
	update_configuration_warnings()


func set_blackboard(val: Blackboard) -> void:
	if not val:
		val = Blackboard.new()
	
	blackboard = val
	
	update_configuration_warnings()


func set_root(val: Composite) -> void:
	if root and root.has_meta(&"RationalTree"):
		root.remove_meta(&"RationalTree")

	root = val

	set_process(can_tick())
	
	if root:

		if actor and not root.resource_name:
			root.resource_name = name + root.get_class_name().back()
		
		if Engine.is_editor_hint():
			root.set_meta(&"RationalTree", self)
	
	update_configuration_warnings()


func get_class_name() -> Array[StringName]:
	return [&"RationalTree"]


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()

	if not root:
		warnings.append("No Root set")
	
	return warnings


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE when has_user_signal(&"predelete"):
			emit_signal(&"predelete")

@icon("../icons/Tree.svg")
@tool
class_name RationalTree extends Node

signal tree_enabled
signal tree_disabled

enum {SUCCESS, FAILURE, RUNNING}

@export var actor: Node: set = set_actor

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Blackboard", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_ALWAYS_DUPLICATE)
var blackboard: Blackboard = Blackboard.new(): set = set_blackboard

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Composite", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_ALWAYS_DUPLICATE)
var root: Composite: set = set_root

var action_debug_label: bool = false


@export var disabled: bool = true:
	set(val):
		if disabled == val: return
		disabled = val
		# upd

		if disabled:
			tree_disabled.emit()
		else:
			tree_enabled.emit()


func _enter_tree() -> void:
	if not actor:
		actor = get_parent()


func _ready() -> void:
	PROPERTY_USAGE_ALWAYS_DUPLICATE
	if not Engine.is_editor_hint():
		disabled = false

# func setup(actor: Node, board: Blackboard) -> void:
# 	pass

func _process(delta: float) -> void:
	if disabled:
		set_process(false)
		return

	root.tick(delta, blackboard, actor)


func tick() -> int:
	if disabled: return FAILURE


	return SUCCESS


## Propegates call to all tree components
func call_tree(method: StringName, args: Array = []) -> void:
	for child: RationalComponent in root.get_children(true):
		if child.has_method(method):
			child.callv(method, args)


func can_tick() -> bool:
	return _get_configuration_warnings().is_empty()


func set_actor(val) -> void:
	actor = val

	update_configuration_warnings()

func set_blackboard(val) -> void:
	blackboard = val

	update_configuration_warnings()

func set_root(val) -> void:
	root = val

	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()

	if not actor:
		warnings.append("No Actor set")

	if not blackboard:
		warnings.append("No Blackboard set")

	if not root:
		warnings.append("No Composite set")

	return warnings
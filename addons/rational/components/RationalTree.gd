@tool
@icon("../icons/Tree.svg")
class_name RationalTree extends Node

signal tree_enabled
signal tree_disabled

enum {SUCCESS, FAILURE, RUNNING}

@export var actor: Node: set = set_actor

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Blackboard", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NEVER_DUPLICATE)
var blackboard: Blackboard = Blackboard.new(): set = set_blackboard

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "Root", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_NO_INSTANCE_STATE) #PROPERTY_USAGE_
var root: Composite: set = set_root

var action_debug_label: bool = false

@export var disabled: bool = true:
	set(val):
		if disabled == val: return
		disabled = val

		if disabled:
			tree_disabled.emit()
			
		else:
			tree_enabled.emit()


func _enter_tree() -> void:
	if not actor:
		actor = get_parent()
	
	
func _ready() -> void:
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
	return not disabled and _get_configuration_warnings().is_empty() 


func set_actor(val: Node) -> void:
	actor = val

	update_configuration_warnings()


func set_blackboard(val: Blackboard) -> void:
	if not val:
		val = Blackboard.new()
	
	blackboard = val
	
	update_configuration_warnings()


func set_root(val: Root) -> void:
	if not val:
		val = Root.new()
	
	root = val
	
	if actor: 
		root.resource_name = actor.name

	if Engine.is_editor_hint() and Engine.has_meta(&"Cache"):
		Engine.get_meta(&"Cache").add(self)
	
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = PackedStringArray()

	if not actor:
		warnings.append("No Actor set")

	return warnings

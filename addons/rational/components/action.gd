@tool
@icon("../icons/Action.svg")
class_name ActionLeaf extends Leaf

@export var name: StringName
@export var action_script: Script
@export var parameter_data: Dictionary = {}

func tick(delta: float, board: Blackboard, actor: Node) -> int:
	if action_script:
		return action_script.static_tick(delta, board, actor)

	return FAILURE

func _get_property_list() -> Array[Dictionary]:
	if not action_script or not Engine.is_editor_hint(): return super.get_property_list()

	var result: Array[Dictionary] =[]
	var script_props: Dictionary = action_script.get_export_properties()

	# for key: String in script_props.keys():
	# 	result.append(
	# 			{
	# 				name = key, 
	# 				type = typeof(script_props[key]),
	# 				usage = 
	# 			}
	# 		)

	return result


# func _get(property: StringName) -> Variant:
#     if property action_script.get_script_property_list()
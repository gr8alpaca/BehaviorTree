@tool
extends EditorScript

var data: Dictionary = {key = "key"}


func _run() -> void:
	#print_node_tree(EditorInterface.get_inspector())
	instantiate_script("res://TestScene/RationalObjects/move.gd")
	
	#print(Array(data.keys().duplicate(), TYPE_STRING, "", null))
	#var scene: Node = get_scene()
	#var gn: GraphNode = scene.get_node("%GraphNode")

func instantiate_script(scr: String) -> Variant:
	var result: Script = load(scr)
	if result.can_instantiate():
		print("IN THEREHEHR")
		return result.new()
	
	print("NAHHH")
	return result

func _on_gui_focus_changed(focus: Control) -> void:
	print_rich("Focus:\t[color=pink]%s[/color]\t@(%1.0f,%1.0f)" % [focus, focus.global_position.x, focus.global_position.y])
	

func print_node_tree(node:Node, level: int = 0) -> void:
	const INDENT: String = "⎯⎯"
	print(INDENT.repeat(level), node.name)
	for child in node.get_children(true):
		if child is Window: continue
		print_node_tree(child, level + 1)

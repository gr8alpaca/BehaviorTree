@tool
extends EditorScript

var data: Dictionary = {key = "key"}
func _run() -> void:
	print(Array(data.keys().duplicate(), TYPE_STRING, "", null))
	

func _on_gui_focus_changed(focus: Control) -> void:
	print_rich("Focus:\t[color=pink]%s[/color]\t@(%1.0f,%1.0f)" % [focus, focus.global_position.x, focus.global_position.y])
	
func print_node_tree(node:Node, level: int = 0) -> void:
	const INDENT: String = "⎯⎯"
	print(INDENT.repeat(level), node.name)
	for child in node.get_children(true):
		if child is Window: continue
		print_node_tree(child, level + 1)

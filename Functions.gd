@tool
extends EditorScript

func _run() -> void:
	var plug: EditorPlugin = Engine.get_singleton(&"RationalPlugin")
	var texture_rect: TextureRect = get_scene()
	
	#print("Plug = Null: ",plug == null)
	#var err:= plug.get_window().gui_focus_changed.connect(_on_gui_focus_changed, CONNECT_DEFERRED)
	
	#var t: Theme = ThemeDB.get_default_theme()
	#for type: String in  t.get_type_list():
		#for icon_name: String in t.get_icon_list(type):
			#print(type, " - ", icon_name)
	
	var se:= EditorInterface.get_script_editor()
	var edits := se.find_children("", "LineEdit",)
	
	#print_node_tree(se)
	#var scripts:= se.get_open_script_editors()
	#var base: ScriptEditorBase = scripts.front()
	#if not base: return
	
	#var containers: Array[Container] = [scripts] 
	#for child in scripts.get_children(true):
		#containers.clear()
		#if child is Container: containers.append()
			#vb = child
			#break
			#
			#
	#printt(vb.get_children(true))


func _on_gui_focus_changed(focus: Control) -> void:
	print_rich("Focus:\t[color=pink]%s[/color]\t@(%1.0f,%1.0f)" % [focus, focus.global_position.x, focus.global_position.y])
	
func print_node_tree(node:Node, level: int = 0) -> void:
	const INDENT: String = "⎯⎯"
	print(INDENT.repeat(level), node.name)
	for child in node.get_children(true):
		if child is Window: continue
		print_node_tree(child, level + 1)

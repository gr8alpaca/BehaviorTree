@tool
class_name Ut extends EditorScript

var data: Dictionary = {key = "key"}

var tw: Tween
func _run() -> void:
	check_in_scene()
	var theme: Theme = EditorInterface.get_editor_theme()
	var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	
	#print(tree.owner.get_path_to(tree))
	EditorInterface.get_editor_paths()
	#print(theme.has_icon(&"RationalComponent", &"EditorIcons"))
	
	#var root: Root = tree.root
	var config_path:= EditorInterface.get_editor_paths().get_cache_dir().path_join("global_script_class_cache.cfg")
	var con:= ConfigFile.new()
	con.load(config_path)
	for sec in con.get_sections():
		for key in con.get_section_keys(sec):
			print(sec,key, con.get_value(sec, key,))
	printt(con.get_value("", "list"))
	
	#tw = Engine.get_main_loop().create_tween().set_loops(5)
	#tw.tween_callback(print_inspector_path).set_delay(0.25)
func check_in_scene() -> void:
	var scene:= get_scene()
	var theme: Theme = EditorInterface.get_editor_theme()
	if not scene or scene is not Node2D: return
	
	var tree: RationalTree = scene.get_node(^"%RationalTree2")
	#printt(inst_to_dict(tree.root ))
	var script: Script = tree.root.get_script()
	
	#script.get_
	printt(type_exists(&"Root"))

func _on_scene_changed(new_scene: Node) -> void:
	print("New scene: ", new_scene)

func print_inspector_path() -> void:
	var inspector:= EditorInterface.get_inspector()
	print_rich("[color=pink]%s[/color]:%s"% [inspector.get_edited_object(),inspector.get_selected_path()])

func find_resource_type(resource_type: StringName) -> PackedStringArray:
	var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	
	while fs.is_scanning():
		print("Waiting for scan...")
		await Engine.get_main_loop().process_frame
		
	return search_dir(resource_type, fs.get_filesystem())


func search_dir(type: StringName, dir: EditorFileSystemDirectory) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	for i: int in dir.get_file_count():
		#result.append("%s: %s"%[dir.get_file(i), dir.get_file_type(i)])
		
		match dir.get_file_type(i):
			
			type:
				result.append("%s: %s"%[dir.get_file(i), dir.get_file_type(i)])
				
			&"PackedScene":
				result += get_packed_resources(type, load(dir.get_file_path(i)))
				
		result.append(dir.get_file_path(i))

	for i: int in dir.get_subdir_count():
		result += search_dir(type, dir.get_subdir(i))
		
	return result

func get_packed_resources(type: StringName, packed: PackedScene) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	for element: Variant in packed.bundled.get("variants", []):
		
		if is_instance_of(element, RationalComponent):
			result.append("%s: %s"%[element.get_class(), element.resource_path])
	return result



func _on_gui_focus_changed(focus: Control) -> void:
	print_rich("Focus:\t[color=pink]%s[/color]\t@(%1.0f,%1.0f)" % [focus, focus.global_position.x, focus.global_position.y])
	

func print_node_tree(node:Node, level: int = 0) -> void:
	const INDENT: String = "⎯⎯"
	print(INDENT.repeat(level), node.name)
	for child in node.get_children(true):
		if child is Window: continue
		print_node_tree(child, level + 1)

## Surrounds [code]txt[/code] in bbc color code with color [code]color[/code]
static func col(txt: String, color: String = "pink") -> String:
	return "[color=%s]%s[/color]" % [color, txt]

static func ts(use_bbcode: bool = true) -> String:
	if use_bbcode: return "[color=pink]%1.3f[/color] secs" % (Time.get_ticks_msec()/1000.0) 
	return "%1.3f secs" % (Time.get_ticks_msec()/1000.0) 

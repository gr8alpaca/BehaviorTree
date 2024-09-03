@tool
extends EditorScript

var data: Dictionary = {key = "key"}


func _run() -> void:
	#print_node_tree(EditorInterface.get_inspector())
	#instantiate_script("res://TestScene/RationalObjects/move.gd")
	var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	var dir:= fs.get_filesystem()
	var sdir:= fs.get_filesystem_path("res://TestScene/RationalObjects/")
	for i: int in sdir.get_file_count():
		Resource
		printt(sdir.get_file_script_class_extends(i) + ": ", sdir.get_file(i))
	#print("\n".join(await find_resource_type(&"RationalComponent")))
	#print(Array(data.keys().duplicate(), TYPE_STRING, "", null))
	#var scene: Node = get_scene()
	#var gn: GraphNode = scene.get_node("%GraphNode")

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

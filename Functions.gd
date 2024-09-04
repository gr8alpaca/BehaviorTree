@tool
extends EditorScript

var data: Dictionary = {key = "key"}


func _run() -> void:
	var s:= get_scene()
	var root: Root = s.get_node("%RationalTree2").root
	#var dict:= inst_to_dict(root)
	#print(dict)
	#var inst: Root = dict_to_inst(dict)
	
	
	#print("Meta: ", root.get_rid())
	#print("Root: ", root)
	
	return
	#print("Instance: ", inst)
	return
	var paths:= ResourceLoader.get_dependencies(root.get_script().resource_path)
	for path: String in paths:
		var id : int = ResourceLoader.get_resource_uid(path)
		ResourceLoader.load(path)
	#print(JSON.stringify(root, "\n", true, true))
	#print(ResourceUID.id_to_text(uid))
	#var_to_bytes_with_objects()
	#var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	#var dir:= fs.get_filesystem()
	#var sdir:= fs.get_filesystem_path("res://TestScene/RationalObjects/")
	
	pass
	
	
	# var test: Root = get_scene().get_node("%RationalTree2").root
	# var dict:= inst_to_dict(test)
	
	#for key in dict.keys():
		#printt(key, "\n", dict[key])
		
	#res://TestScene/test_scene_character.tscn::Resource_ykp3e
	
	
	
	
	#for i: int in sdir.get_file_count():
		#printt(sdir.get_file_script_class_extends(i) + ": ", sdir.get_file_script_class_name(i))
		#print(fs.get_file_type(sdir.get_file_path(i)))
	
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

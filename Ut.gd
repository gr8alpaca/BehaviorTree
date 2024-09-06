@tool
class_name Ut extends EditorScript

var data: Dictionary = {key = "key"}

var tw: Tween

const UTIL:= preload("res://addons/rational/util.gd")

func _run() -> void:
	var theme: Theme = EditorInterface.get_editor_theme()
	var fs : EditorFileSystem = EditorInterface.get_resource_filesystem()
	var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	var scene:= get_scene()
	var cache:= load("res://addons/rational/data/cache.tres")
	print(JSON.stringify(cache.get_property_list(), "\t"))
	#var t: Tree = plugin.editor.get_node(^"%ItemListLeaf")
	#var mainscreen:= scene.get_parent().get_parent().get_parent()
	#print(scene.get_path())
	plugin._edit(scene)
	#print("Node: ", mainscreen, "CHILD COUNT: ", mainscreen.get_child_count())
	#print(mainscreen.get_children())
	#var s:= JSON.stringify(cache)
	#print(s)
	#print(theme.has_icon(&"RationalTree", &"EditorIcons"))
	return
	

	

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

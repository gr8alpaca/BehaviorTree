@tool
class_name Ut extends EditorScript

var data: Dictionary = {key = "key"}

var tw: Tween

#const Util := preload("res://addons/rational/util.gd")
#const RationalPicker = preload("res://addons/rational/plugins/inspector/rational_property.gd")
func _run() -> void:
	var class_list: Array[Dictionary] = ProjectSettings.get_global_class_list().filter(func(x: Dictionary)->bool: return x.class in ["Composite", "Leaf", "Decorator", "RationalComponent", "RationalTree"] )
	for d in class_list:
		pass
			

	
	print(ResourceLoader.get_dependencies("res://addons/rational/components/fallback.gd"))

	return
	var theme: Theme = EditorInterface.get_editor_theme()
	var fs: EditorFileSystem = EditorInterface.get_resource_filesystem()
	var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	var scene : PopupMenu = get_scene()
	var submenu: PopupMenu = create_submenu(["Sub1", "Sub2", "Sub3"])
	scene.add_submenu_node_item( "Sub1", submenu, )
	submenu.owner = scene
	
	
func create_submenu(text: PackedStringArray) -> PopupMenu:
	var menu: PopupMenu = PopupMenu.new()
	var id: int = 0
	for item: String in text:
		menu.add_item(item,id,)

	return menu 
func foo_print(string: String = "foo_print() called!") -> void:
	printt(string)

func print_inspector_path() -> void:
	var inspector := EditorInterface.get_inspector()
	print_rich("[color=pink]%s[/color]:%s" % [inspector.get_edited_object(), inspector.get_selected_path()])

func find_resource_type(resource_type: StringName) -> PackedStringArray:
	var fs: EditorFileSystem = EditorInterface.get_resource_filesystem()
	
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
				result.append("%s: %s" % [dir.get_file(i), dir.get_file_type(i)])
				
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
			result.append("%s: %s" % [element.get_class(), element.resource_path])
	return result


func _on_gui_focus_changed(focus: Control) -> void:
	print_rich("Focus:\t[color=pink]%s[/color]\t@(%1.0f,%1.0f)" % [focus, focus.global_position.x, focus.global_position.y])
	

func print_node_tree(node: Node, level: int = 0) -> void:
	const INDENT: String = "⎯⎯"
	print(INDENT.repeat(level), node.name)
	for child in node.get_children(true):
		if child is Window: continue
		print_node_tree(child, level + 1)

## Surrounds [code]txt[/code] in bbc color code with color [code]color[/code]
static func col(txt: String, color: String = "pink") -> String:
	return "[color=%s]%s[/color]" % [color, txt]

static func ts(use_bbcode: bool = true) -> String:
	if use_bbcode: return "[color=pink]%1.3f[/color] secs" % (Time.get_ticks_msec() / 1000.0)
	return "%1.3f secs" % (Time.get_ticks_msec() / 1000.0)

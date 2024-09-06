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
	
	var t: Tree = plugin.editor.get_node(^"%ItemListLeaf")
	#UTIL.initialize_icons()
	#t.icons.merge(Engine.get_meta(&"Icons", {}))
	
	t.columns = 2
	t.clear()
	
	var t1:= t.create_item()
	
	t1.set_text_alignment(0, HORIZONTAL_ALIGNMENT_LEFT)
	#t1.set_cell_mode(0, TreeItem.CELL_MODE_ICON)
	t1.set_icon_region(0, Rect2(Vector2.ZERO, Vector2(16,16)*EditorInterface.get_editor_scale()))
	t1.set_icon(0, UTIL.get_icon(&"Leaf"))
	
	#t1.set_expand_right()
	t1.set_editable(1, false)
	t1.set_cell_mode(1, TreeItem.CELL_MODE_STRING)
	t1.set_text_alignment(1, HORIZONTAL_ALIGNMENT_LEFT)
	t1.set_text(1, "Test Item String")
	
	t1.set_text_alignment(1, HORIZONTAL_ALIGNMENT_RIGHT)
	var button_id: int = t1.get_button_count(1)
	t1.add_button(1, theme.get(&"EditorIcons/icons/GuiVisibilityVisible"), button_id, false, "Make tree item visible")
	t1.set_metadata(1, true)

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

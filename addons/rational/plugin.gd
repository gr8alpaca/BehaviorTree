@tool
extends EditorPlugin

const Util := preload("res://addons/rational/util.gd")
const Cache := preload("data/cache.gd")

var inspector_plugin: EditorInspectorPlugin

## Cache for all RationalComponent resources. 
var cache: Cache

var editor: PanelContainer
var frames: RefCounted

#region Enter/Exit

func _enter_tree() -> void:
	project_settings_changed.connect(_on_project_settings_changed)
	resource_saved.connect(_on_resource_saved)
	scene_saved.connect(_save_external_data.unbind(1))
	scene_changed.connect(_on_scene_changed)
	EditorInterface.get_file_system_dock().files_moved.connect(_on_file_moved)

	name = &"Rational"

	
	if Engine.is_editor_hint():
		Engine.register_singleton(&"Rational", self)

		cache = preload("data/cache.gd").new()
		Engine.set_meta(&"Cache", cache)
		
		frames = preload("editor/editor_style.gd").new()
		Engine.set_meta(&"Frames", editor)
		
		editor = preload("editor/main.tscn").instantiate()
		Engine.set_meta(&"Main", editor)
		
		editor.hide()
		EditorInterface.get_editor_main_screen().add_child(editor)
		inspector_plugin = preload("plugins/inspector/inspector_plugin.gd").new()
		add_inspector_plugin(inspector_plugin)
		
		
		print("Rational initialized")


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		editor.close()
		
		remove_inspector_plugin(inspector_plugin)
		inspector_plugin = null
		
		Engine.unregister_singleton(&"Rational")
		frames = null
		
		
		Engine.remove_meta(&"Cache")
		Engine.remove_meta(&"Frames")
		Engine.remove_meta(&"Main")

		# TODO: Completely remove cache and deconstruct

#endregion


func _on_file_moved(old_file: String, new_file: String) -> void:
	if cache: cache.move_file_path(old_file, new_file)


func _on_resource_saved(res: Resource) -> void:
	print_rich("Resource saved: %s([color=yellow]%s[/color]) @ [color=pink]%s[/color]" % [res.resource_name, res, res.resource_path])
	if res is RationalComponent and ".tscn" not in res.resource_path:
		pass


func _handles(object: Object) -> bool:
	return object is RationalTree and EditorInterface.get_inspector().get_edited_object() != object


func _edit(object: Object) -> void:
	if cache and object:
		if object not in cache.trees:
			cache.add_tree(object as RationalTree)
		
	# if EditorInterface.get_inspector().get_edited_object() != object:
	EditorInterface.inspect_object(object, "", true)


# func focus_object(object: RationalComponent) -> void:
# 	pass


func _make_visible(visible: bool) -> void:
	editor.make_visible(visible)

func _has_main_screen() -> bool:
	return true

func _get_plugin_icon() -> Texture2D:
	return preload("icon.svg")

func _get_plugin_name() -> String:
	return "Rational"


#region Unused

func _on_scene_changed(node: Node) -> void:
	pass

func _save_external_data() -> void:
	pass


func _on_project_settings_changed() -> void:
	pass


func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass

#endregion
@tool
extends EditorPlugin

const Util := preload("res://addons/rational/util.gd")
const Cache := preload("data/cache.gd")

var inspector_plugin: RefCounted

## Cache for all RationalComponent resources. 
var cache: Cache

var editor: PanelContainer
var frames: RefCounted


func _enter_tree() -> void:
	project_settings_changed.connect(_on_project_settings_changed)
	resource_saved.connect(_on_resource_saved)
	scene_saved.connect(_save_external_data.unbind(1))
	scene_changed.connect(_on_scene_changed)
	
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
		inspector_plugin = preload("inspector/inspector_plugin.gd").new()
		add_inspector_plugin(inspector_plugin)
		
		
		print("Rational initialized")


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		editor.close()
		
		remove_inspector_plugin(inspector_plugin)
		inspector_plugin = null
		
		Engine.unregister_singleton(&"Rational")
		frames = null
		
		for sname: StringName in [&"Cache", &"Frames", &"Main"]:
			Engine.remove_meta(sname)
		
		Engine.remove_meta(&"Cache")
		Engine.remove_meta(&"Frames")
		Engine.remove_meta(&"Main")

		# TODO: Completely remove cache and deconstruct


func _on_resource_saved(res: Resource) -> void:
	print_rich("Resource saved: %s([color=yellow]%s[/color]) @ [color=pink]%s[/color]" % [res.resource_name, res, res.resource_path])
	

func _on_scene_changed(node: Node) -> void:
	# print_rich("Scene changed to: [color=yellow]", node,"[/color] @ ", Ut.ts())
	pass


func focus_object(object: RationalComponent) -> void:
	pass


func _edit(object: Object) -> void:
	if cache and object:
		if object not in cache.trees: 
			cache.add_tree(object as RationalTree)
		
	if EditorInterface.get_inspector().get_edited_object() != object:
		EditorInterface.inspect_object(object, "", true)


func _handles(object: Object) -> bool:
	return object is RationalTree and EditorInterface.get_inspector().get_edited_object() != object


func _make_visible(visible: bool) -> void:
	editor.make_visible(visible)


func _save_external_data() -> void:
	pass

func _on_project_settings_changed() -> void:
	pass

func _has_main_screen() -> bool:
	return true

func _get_plugin_icon() -> Texture2D:
	return preload("icon.svg")

func _get_plugin_name() -> String:
	return "Rational"


func _enable_plugin() -> void:
	pass

func _disable_plugin() -> void:
	pass

@tool
extends EditorPlugin

const ICON := preload("icon.svg")

## Cache for all RationalComponent resources. 
var cache: RationalData

var editor: RationalEditor
var frames: RefCounted


func _enter_tree() -> void:
	name = &"Rational"
	Engine.register_singleton(&"Rational", self)
	
	frames = preload("editor/editor_style.gd").new()
	editor = preload("editor/main.tscn").instantiate()
	
	
	editor.hide()
	EditorInterface.get_editor_main_screen().add_child(editor)

	print("Rational initialized")
	resource_saved.connect(_on_resouce_saved)
	scene_saved.connect(_on_scene_saved)


func _on_resouce_saved(resource: Resource) -> void:
	print("Resource Saved: ", resource, resource.get_class())


func _on_scene_saved(filepath: String) -> void:
	print("Scene saved @ ", filepath)


func _exit_tree() -> void:
	Engine.unregister_singleton(&"Rational")
	if editor: editor.close()
		

func _edit(object: Object) -> void:
	# if object is RationalTree:
	# 	EditorInterface.edit_node(object)
	if object is RationalComponent:
		if object is Root: pass

	# EditorInterface.get_inspector()
	# EditorInterface.edit_node(object)

	
func _handles(object: Object) -> bool:
	return false # object is RationalTree or object is RationalComponent


func _make_visible(visible: bool) -> void:
	editor.make_visible(visible)


func _save_external_data() -> void:
	pass


func _has_main_screen() -> bool:
	return true

func _get_plugin_name() -> String:
	return "Rational"
func _get_plugin_icon() -> Texture2D:
	return ICON

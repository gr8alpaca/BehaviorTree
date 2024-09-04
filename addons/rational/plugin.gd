@tool
extends EditorPlugin

## Cache for all RationalComponent resources. 
var cache: Resource

var editor: PanelContainer
var frames: RefCounted

func _enter_tree() -> void:
	name = &"Rational"
	
	if Engine.is_editor_hint():
		Engine.register_singleton(&"Rational", self)
		
		cache = RationalData.load_cache()
		Engine.set_meta(&"Cache", cache)
		
		frames = preload("editor/editor_style.gd").new()
		Engine.set_meta(&"Frames", editor)
		
		editor = preload("editor/main.tscn").instantiate()
		Engine.set_meta(&"Main", editor)
		
		editor.hide()
		EditorInterface.get_editor_main_screen().add_child(editor)
		
		
		
		
		print("Rational initialized")
	

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		editor.close()
		
		Engine.unregister_singleton(&"Rational")
		frames = null
		
		for sname: StringName in [&"Cache" ,&"Frames", &"Main"]:
			Engine.remove_meta(sname)
				

func focus_object(object: RationalComponent) -> void:
	pass

func _edit(object: Object) -> void:
	# if object is RationalTree:
	# 	EditorInterface.edit_node(object)
	if object is RationalComponent:
		if object is Root: pass
			
	var s = EditorInterface.get_inspector()
	# EditorInterface.edit_node(object)

	
func _handles(object: Object) -> bool:
	return false # object is RationalTree or object is RationalComponent


func _make_visible(visible: bool) -> void:
	editor.make_visible(visible)


func _save_external_data() -> void:
	if cache: cache.save_cache()


func _has_main_screen() -> bool:
	return true
const ICON := preload("icon.svg")
func _get_plugin_icon() -> Texture2D:
	return ICON
func _get_plugin_name() -> String:
	return "Rational"

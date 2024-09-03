@tool
extends EditorPlugin

const ICON := preload("icon.svg")

var frames: RefCounted
var editor: RationalEditor

func _enter_tree() -> void:
	name = &"Rational"
	Engine.register_singleton(&"Rational", self)
	
	frames = preload("editor/editor_style.gd").new()
	editor = preload("editor/editor_window.tscn").instantiate()
	#preload("inspector/inspector_plugin.gd").new()
	#add_inspector_plugin()
	editor.hide()
	EditorInterface.get_editor_main_screen().add_child(editor)

	print("Rational initialized")

func _exit_tree() -> void:
	Engine.unregister_singleton(&"Rational")
	if editor: editor.close()

func _has_main_screen() -> bool:
	return true


# func _edit(object: Object) -> void:
# 	pass

# func _handles(object: Object) -> bool:
# 	return object is RationalComponent


func _make_visible(visible: bool) -> void:
	editor.make_visible(visible)


func _save_external_data() -> void:
	pass

func _get_plugin_name() -> String:
	return "Rational"
func _get_plugin_icon() -> Texture2D:
	return ICON

@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	return object is RationalTree


func _parse_begin(object: Object) -> void:
	var but:= create_button()
	add_custom_control(but)
	
	
func create_button() -> Button:
	var button: Button =Button.new()
	button.text = "Open Tree"
	button.icon = button.get_theme_icon(&"ClassList", &"EditorIcons") #EditorInterface.get_editor_theme().get_icon()	
	button.pressed.connect(_on_button_pressed)

	return button


func _on_button_pressed() -> void:
	var plugin: EditorPlugin = Engine.get_singleton("Rational")
	plugin.editor
	EditorInterface.set_main_screen_editor("Rational")
	pass

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, 
	hint_string: String, usage_flags: int, wide: bool) -> bool:

	return false

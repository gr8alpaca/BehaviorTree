@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	return object is RationalTree


func _parse_begin(object: Object) -> void:
	if not Engine.has_meta(&"Main"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta \"[color=red]Main[/color]\"")
		return
	
	#var but: Button = create_button()
	#but.pressed.connect(Engine.get_meta(&"Main").edit_tree.bind(object))
	#add_custom_control(but)
	

func create_button(callable: Callable) -> Control:
	var hbox:= HBoxContainer.new()
	hbox.theme = EditorInterface.get_editor_theme() 
	
	var button: Button =Button.new()
	button.theme = EditorInterface.get_editor_theme() 
	button.theme_type_variation = &"InspectorActionButton"
	
	button.text = "Edit Tree..."
	button.tooltip_text = "Switch to RationalTree Editor."
	
	button.icon = button.theme.get_icon(&"ClassList", &"EditorIcons")
	button.icon_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	if callable: button.pressed.connect(callable)
		
	return button


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, 
	hint_string: String, usage_flags: int, wide: bool) -> bool:
		
	if name != "actor": 
		return false
		
	if not Engine.has_meta(&"Main"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta \"[color=red]Main[/color]\"")
		return false

	add_custom_control(create_button(Engine.get_meta(&"Main").edit_tree.bind(object)))
	
	return false

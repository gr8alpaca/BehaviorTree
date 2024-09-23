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
	var button: Button = Button.new()
	button.theme = EditorInterface.get_editor_theme()
	button.theme_type_variation = &"InspectorActionButton"
	
	button.text = "Edit Behavior Tree"
	button.tooltip_text = "Switch to the behavior tree editor tab."
	
	button.icon = button.theme.get_icon(&"ExternalLink", &"EditorIcons")
	
	# button.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_HEIGHT, 2)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	if callable: button.pressed.connect(callable)
		
	return button


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint,
	hint_string: String, usage_flags: int, wide: bool) -> bool:
		
	if name != "actor":
		return false
		
	if not Engine.has_meta(&"Main"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta \"[color=red]Main[/color]\"")
		return false

	var margins: Vector2 = Vector2(4,4) * EditorInterface.get_editor_scale()
	var margin_container:= MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", margins.x)
	margin_container.add_theme_constant_override("margin_right", margins.x)
	margin_container.add_theme_constant_override("margin_top", margins.y)
	margin_container.add_theme_constant_override("margin_bottom", margins.y)
	margin_container.add_child(create_button(Engine.get_meta(&"Main").edit_tree.bind(object)))
	add_custom_control(margin_container)
	
	return false

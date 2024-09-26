@tool
extends EditorInspectorPlugin

const RationalPicker:= preload("rational_property.gd")

func _can_handle(object: Object) -> bool:
	return object is RationalTree


func create_button() -> Control:
	var button: Button = Button.new()
	button.theme = EditorInterface.get_editor_theme()
	button.theme_type_variation = &"InspectorActionButton"
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	return button


func create_margin_container(child_control: Control = null, margins: Vector2 = Vector2(4, 4), ) -> MarginContainer:
	margins * EditorInterface.get_editor_scale()
	var margin_container := MarginContainer.new()
	margin_container.add_theme_constant_override("margin_left", margins.x)
	margin_container.add_theme_constant_override("margin_right", margins.x)
	margin_container.add_theme_constant_override("margin_top", margins.y)
	margin_container.add_theme_constant_override("margin_bottom", margins.y)
	if child_control: margin_container.add_child(child_control)
	return margin_container


func _parse_category(object: Object, category: String) -> void:
	if category != "RationalTree.gd": return

	var button: Button = create_button()
	button.text = "Edit Behavior Tree"
	button.tooltip_text = "Switch to the behavior tree editor tab."
	button.icon = button.get_theme_icon(&"ExternalLink", &"EditorIcons")
	button.pressed.connect(Engine.get_meta(&"Main").edit_tree.bind(object))

	add_custom_control(create_margin_container(button))


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "root": pass
	# if name != "actor":
	# 	return false
	
	# if not Engine.has_meta(&"Main"):
	# 	print_rich("[color=red]ERROR[/color]: Engine does not have meta \"[color=red]Main[/color]\"")
	# 	return false
	
	# var button: Button = create_button()
	# button.text = "Edit Behavior Tree"
	# button.tooltip_text = "Switch to the behavior tree editor tab."
	# button.icon = button.get_theme_icon(&"ExternalLink", &"EditorIcons")
	# button.pressed.connect(Engine.get_meta(&"Main").edit_tree.bind(object))

	# add_custom_control(create_margin_container(button))

	return false

@tool
extends PanelContainer

var floating_window: Window

func _enter_tree() -> void:
	#var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	#var file_dock: FileSystemDock = EditorInterface.get_file_system_dock()
	for sig: Signal in [
			EditorInterface.get_inspector().resource_selected, 
			EditorInterface.get_file_system_dock().instantiate
		]:
			var callable: Callable = get("_on_" + sig.get_name())
			if not sig.is_connected(callable): sig.connect(callable)
			



func _on_instantiate(paths: PackedStringArray) -> void:
	pass


func _on_resource_selected(resource: Resource, path: String) -> void:
	pass

func _on_scene_changed(scene_root: Node) -> void:
	pass

func _on_make_floating() -> void:
	var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	
	if not plugin:
		return
		
	if floating_window:
		_on_window_close_requested()
		return

	get_node("%MakeFloating").hide()
	var border_size := Vector2(4, 4) * EditorInterface.get_editor_scale()
	var editor_interface: EditorInterface = plugin.get_editor_interface()
	var editor_main_screen := editor_interface.get_editor_main_screen()
	get_parent().remove_child(self)
	
	floating_window = Window.new()

	var panel := Panel.new()
	panel.add_theme_stylebox_override(
		"panel",
		editor_interface.get_base_control().get_theme_stylebox("PanelForeground", "EditorStyles")
	)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	floating_window.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_child(self)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_right", border_size.x)
	margin.add_theme_constant_override("margin_left", border_size.x)
	margin.add_theme_constant_override("margin_top", border_size.y)
	margin.add_theme_constant_override("margin_bottom", border_size.y)
	panel.add_child(margin)

	floating_window.title = "Rational"
	floating_window.wrap_controls = true
	floating_window.min_size = Vector2i(600, 350)
	floating_window.size = size
	floating_window.position = editor_main_screen.global_position
	floating_window.transient = true
	floating_window.close_requested.connect(_on_window_close_requested)
	EditorInterface.set_main_screen_editor("2D")
	editor_interface.get_base_control().add_child(floating_window)


func _on_window_close_requested() -> void:
	get_parent().remove_child(self)
	EditorInterface.set_main_screen_editor("Rational")
	EditorInterface.get_editor_main_screen().add_child(self)
	floating_window.queue_free()
	floating_window = null
	get_node("%MakeFloating").show()


func close() -> void:
	
	## MOVE THESE TO READY!!!!!!!
	for sig: Signal in \
		[
			EditorInterface.get_inspector().resource_selected, 
			EditorInterface.get_file_system_dock().instantiate,
		]:
		var callable: Callable = get("_on_" + sig.get_name())
		if sig.is_connected(callable): sig.disconnect(callable)
	
	
	if floating_window:
		floating_window.queue_free()
	else:
		queue_free()


func make_visible(is_visible: bool) -> void:
	if floating_window:
		floating_window.grab_focus()
		EditorInterface.set_main_screen_editor.call_deferred("2D")
	else:
		visible = is_visible

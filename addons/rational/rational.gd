@tool
extends EditorPlugin

const NAME: StringName = &"RationalPlugin"

func _init() -> void:
	name = NAME

func _enter_tree() -> void:
	name = NAME
	Engine.register_singleton(NAME, self)
	print_rich("[color=yellow]RationalPlugin[/color] -> [color=green]Entered Tree[/color]")
	
	#init_editor()
	

func init_editor() -> void:
	var bottom_panel: Control =Control.new()
	add_control_to_bottom_panel(bottom_panel, bottom_panel.name,) # TODO: add shortcut...
	
func _exit_tree() -> void:
	Engine.unregister_singleton(NAME)



#func force_multi_window_mode() -> void:
	#if EditorInterface.is_multi_window_enabled(): return
	#var edit_settings: EditorSettings = EditorInterface.get_editor_settings()
	#edit_settings.set_setting()

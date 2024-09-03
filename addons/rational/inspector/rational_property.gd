@tool
extends EditorProperty

func _ready() -> void:
	var but: Button = preload("rational_picker.gd").new()
	but.text = "Add child from script..."
	but.icon = preload("../editor/icons/Load.svg")
	but.pressed.connect(_on_button_pressed)
	
func _on_button_pressed() -> void:
	var file_dialog:= EditorFileDialog.new()
	file_dialog.file_mode = EditorFileDialog.FILE_MODE_OPEN_FILE
	file_dialog.add_filter("*.gd", "GDScript")
	EditorInterface.get_base_control().add_child(file_dialog)
	file_dialog.popup_file_dialog()
	file_dialog.file_selected.connect(_on_file_dialog_file_selected)
	file_dialog.close_requested.connect(_on_file_dialog_close_requested.bind(file_dialog))

func _update_property() -> void:
	pass
 

func _on_file_dialog_close_requested(file_dialog: EditorFileDialog) -> void:
	if file_dialog:
		file_dialog.free()
		

func _on_file_dialog_file_selected(file: String) -> void:
	pass

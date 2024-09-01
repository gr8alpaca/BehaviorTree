@tool
class_name ResourceList extends ItemList


@export var resource_type: StringName = &""


func _init(resource_class_filter: StringName = &"") -> void:
	resource_type = resource_class_filter
	name = resource_type + "FileList"


func _enter_tree() -> void:
	init_list_resources(EditorInterface.get_resource_filesystem())


func init_list_resources(res_file_system: EditorFileSystem) -> void:
	var file_system : EditorFileSystemDirectory = res_file_system.get_filesystem()
	while res_file_system.is_scanning():
		await get_tree().process_frame


func bind_search(searchbar: LineEdit) -> void:
	searchbar.text_changed.connect(_on_searchbar_text_changed)


func _on_searchbar_text_changed(search_string: String) -> void:
	pass


# Recursively find any dialogue files in a directory
func _get_dialogue_files_in_filesystem() -> Array[Resource]:
	var files: PackedStringArray = []
	var file_system : EditorFileSystemDirectory = EditorInterface\
		.get_resource_filesystem()\
		.get_filesystem()





	

	return files
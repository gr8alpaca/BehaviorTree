@tool
extends ItemList
	
@export var roots: Array[RationalComponent] = []


func _enter_tree() -> void:
	build_list()


func build_list() -> void:
	EditorInterface.get_open_scenes()


func parse_packed(filepath: String) -> void:
	pass


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

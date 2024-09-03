extends Node


var cache: Array[Resource] = []


func build_cache() -> void:
    var file_system: EditorFileSystemDirectory = EditorInterface \
		.get_resource_filesystem() \
		.get_filesystem()

# func get_resources_of_type(type: String) -> Array[Resource]:
#     resource_removed
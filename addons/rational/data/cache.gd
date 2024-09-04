@tool
class_name RationalData extends Resource


signal about_to_write


func add_resource(res: Resource) -> void:
	pass

func get_directory_resource_paths(dir: EditorFileSystemDirectory) -> PackedStringArray:
	var result: PackedStringArray = PackedStringArray()
	# for i: int in dir.get_file_count(i):
	# 	match file_dir.get_file_type(i):
	# 		"PackedScene":
	# 			pass
	return result


func save_cache() -> void:
	about_to_write.emit()

	# self.take_over_path("rational_cache.tres"

	ResourceSaver.save(self, "rational_cache.tres", ResourceSaver.FLAG_CHANGE_PATH | ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)


# func build_cache() -> void:
# 	var file_system: EditorFileSystem = EditorInterface.get_resource_filesystem()

# 	while file_system.is_scanning():
# 		await Engine.get_main_loop().process_frame

# 	var file_dir: EditorFileSystemDirectory = file_system.get_filesystem()

	# for i: int in file_dir.get_file_count(i):
	# 	pass
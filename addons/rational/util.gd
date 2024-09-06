@tool

static var icons: Dictionary = {} # "Class" = <Texture2D>

static func get_invalid_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get(&"EditorIcons/icons/FileBroken")

static func initialize_icons() -> void:
	var icons: Dictionary = {}
	var global_class: Dictionary = {}

	for class_info: Dictionary in ProjectSettings.get_global_class_list():
		if "/addons/rational/" not in class_info["path"]: continue
		global_class[class_info["class"]] = class_info


	for custom_class: StringName in global_class.keys():
		var class_index_name: StringName = custom_class

		while class_index_name != "" and global_class.get(class_index_name, {}).get("icon", "") == "":
			class_index_name = global_class.get(class_index_name, {}).get("base", "")

		if class_index_name != "":
			icons[class_index_name] = load(global_class.get(class_index_name, {}).get("icon", ""))


	var theme: Theme = EditorInterface.get_editor_theme()

	icons["visible"] = theme.get(&"EditorIcons/icons/GuiVisibilityVisible")
	icons["hidden"] = theme.get(&"EditorIcons/icons/GuiVisibilityHidden")
	

	Engine.set_meta(&"Icons", icons)

	Engine.get_singleton(&"Rational").tree_exiting.connect(Engine.remove_meta.bind(&"Icons"))

## Must extend RationalComponent or RationalTree 
static func get_icon(resource_class: StringName) -> Texture2D:
	for dict: Dictionary in ProjectSettings.get_global_class_list():

		if dict["class"] != resource_class:
			continue

		if dict["icon"]:
			return load(dict["icon"])

		return get_icon(dict.get("base", "RationalComponent"))

	return get_invalid_icon()

## Recursively finds all files in a given directory.
static func get_files_in_dir(dir: String) -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(dir): return PackedStringArray()
	var files: PackedStringArray = PackedStringArray()
	for file: String in DirAccess.get_files_at(dir):
		files.append(dir.path_join(file))
	for subdir: String in DirAccess.get_directories_at(dir):
		files += get_files_in_dir(dir.path_join(subdir))
	return files
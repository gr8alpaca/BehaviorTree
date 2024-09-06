@tool

static func theme() -> Theme:
	return EditorInterface.get_editor_theme()
	
static func has_editor_icon(name: StringName) -> bool:
	return theme().has_icon(name, &"")
	
static func editor_icon(name: StringName) -> Texture2D:
	return theme().get_icon(name, &"EditorIcons") if has_editor_icon(name) else invalid_icon()


static func invalid_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon(&"FileBroken", &"EditorIcons")


static func missing_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon(&"MissingResource", &"EditorIcons")


static func icon(name: StringName) -> Texture2D:
	if name:
		for class_info: Dictionary in ProjectSettings.get_global_class_list():
			if class_info["class"] != name: continue
			
			if class_info["icon"]: 
				return load(class_info["icon"])
			else:
				return icon(class_info["base"])
				
	return invalid_icon()
	

static func initialize_icons() -> void:
	var theme: Theme = EditorInterface.get_editor_theme()
	var icons: Dictionary = {}
	var global_class: Dictionary = {}

	for class_info: Dictionary in ProjectSettings.get_global_class_list():
		if "/addons/rational/" not in class_info["path"]: continue
		#global_class[class_info["class"]] = class_info
		if class_info.icon:
			theme.set_icon(class_info.class, &"EditorIcons", load(class_info.icon))
			
	#
	#for custom_class: StringName in global_class.keys():
		#var class_index_name: StringName = custom_class
#
		#while class_index_name != "" and global_class.get(class_index_name, {}).get("icon", "") == "":
			#class_index_name = global_class.get(class_index_name, {}).get("base", "")
#
		#if class_index_name != "":
			#icons[custom_class] = load(global_class.get(class_index_name, {}).get("icon", ""))
			#
	#
	#Engine.set_meta(&"Icons", icons)
#
	#Engine.get_singleton(&"Rational").tree_exiting.connect(Engine.remove_meta.bind(&"Icons"))

## Must extend RationalComponent or RationalTree 
static func get_icon(resource_class: StringName) -> Texture2D:
	for dict: Dictionary in ProjectSettings.get_global_class_list():

		if dict["class"] != resource_class:
			continue

		if dict["icon"]:
			return load(dict["icon"])
		
		return get_icon(dict.get("base", "RationalComponent"))

	return invalid_icon()


static func serialize(obj: Object) -> String:
	if not obj: return ""
	
	var object_data: Dictionary = \
		{
			"class" : obj.get_class(),
			"script" : obj.get_script().resource_path,
		}
		
	for property: Dictionary in obj.get_property_list():
		if (property.usage & PROPERTY_USAGE_STORAGE):
			pass
	
	return ""


## Recursively finds all files in a given directory.
static func get_files_in_dir(dir: String) -> PackedStringArray:
	if not DirAccess.dir_exists_absolute(dir): return PackedStringArray()
	var files: PackedStringArray = PackedStringArray()
	for file: String in DirAccess.get_files_at(dir):
		files.append(dir.path_join(file))
	for subdir: String in DirAccess.get_directories_at(dir):
		files += get_files_in_dir(dir.path_join(subdir))
	return files

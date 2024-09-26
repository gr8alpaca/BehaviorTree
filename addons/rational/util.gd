@tool

static var icons: Dictionary

static func editor_icon(name: StringName) -> Texture2D:
	return icons.get_or_add(name, EditorInterface.get_editor_theme().get_icon(name, &"EditorIcons"))

static func invalid_icon() -> Texture2D:
	return icons.get_or_add(&"invalid", EditorInterface.get_editor_theme().get_icon(&"FileBroken", &"EditorIcons"))

static func missing_icon() -> Texture2D:
	return icons.get_or_add(&"missing", EditorInterface.get_editor_theme().get_icon(&"MissingResource", &"EditorIcons"))

## Must extend RationalComponent or RationalTree 
static func get_class_icon(names: Array[StringName]) -> Texture2D:
	var class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()
	
	if not names.is_empty():
		var name: StringName = names.pop_back()

		for dict: Dictionary in class_list:
			if dict. class == name and dict.icon:
				return icons.get_or_add(name, load(dict.icon))
		
		return icons.get_or_add(name, get_class_icon(names))

	return icons.get_or_add(&"invalid", EditorInterface.get_editor_theme().get_icon(&"FileBroken", &"EditorIcons"))

static func icon_by_string(class_string: StringName) -> Texture2D:
	return get_class_icon([class_string])
@tool
extends EditorResourceTooltipPlugin



func _handles(type: String) -> bool:
	while type in ProjectSettings.get_global_class_list().map(func(dict: Dictionary) -> String: return dict.get("name", "")):
		if type == "RationalComponent": 
			return true
		
	
	return type == "RationalComponent"

func get_thumbnail_size() -> int:
	return EditorInterface.get_editor_settings().get("docks/filesystem/thumbnail_size")
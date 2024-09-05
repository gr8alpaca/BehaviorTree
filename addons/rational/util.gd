@tool

static var icons: Dictionary = {} # "Class" = <Texture2D>

static func get_icon(res: Resource) -> Texture2D:
	#if res is Composite:
		#if res is Fallback: return preload("composite")
		
	
	if res is Leaf:
		if res is ActionLeaf: return preload("icons/ActionLeaf.svg")
		if res is ConditionLeaf: return preload("icons/Conditional.svg")
		return preload("res://addons/rational/icons/Leaf.svg")
		
	
	
	return null

static func init_icons() -> void:
	if not Engine.is_editor_hint(): return
	var config_path:= EditorInterface.get_editor_paths().get_cache_dir().path_join("global_script_class_cache.cfg")
	var con:= ConfigFile.new()

	#for file: String in DirAccess.get_files_at("icons")

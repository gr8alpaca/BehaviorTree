@tool
extends Resource
const PATH: String = "res://addons/rational/data/cache.tres"

signal added(root: Root)
signal removed(root: Root)


@export var force_save: bool:
	set(val):
		if val: save_cache()


@export var data: Dictionary = \
	{
		# resource = 
		#	{
		#		scene = {
		#			scene_file_path = "res://addons/rational/editor/main.tscn",
		#			node_path = tree.get_path(),
		#			id = resource.resource_scene_unique_id,
		#		is_root = false,
		#		is_root = false,
		#	},
		# 
	}


# @export_custom(PROPERTY_HINT_ARRAY_TYPE, "Resource", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | PROPERTY_USAGE_NEVER_DUPLICATE)
@export var cache: Array[Resource] = []


func add(tree: RationalTree) -> void:
	var root: Root = tree.root
	if root not in cache:
		cache.append(root)
		added.emit(root)
	save_cache()


func remove(root: Root) -> void:
	removed.emit(root)


func save_cache() -> void:
	for item: Resource in cache:
		if ResourceLoader.get_resource_uid(item.resource_path) == -1:
			assign_uid(item)
	var err: int = ResourceSaver.save(self, PATH, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	if err != OK:
		printerr("\t ERROR(%s): Could not save at path: " % error_string(err), PATH, )


func assign_uid(item: Resource) -> void:
	var id: int = ResourceUID.create_id()
	ResourceUID.set_id(id, item.resource_path)
	data[id] = item
	print_rich("UID Created: " + Ut.col(str(id), "cyan"), "\tResource: ", Ut.col(str(item), "orange"))
	

static func load_cache() -> Resource:
	if not ResourceLoader.exists(PATH):
		var data: Resource = preload("res://addons/rational/data/cache.gd").new()
		data.resource_name = "RationalCache"
		data.resource_path = PATH
		data.save_cache()
		return data
	
	var res:= ResourceLoader.load(PATH, "Resource", ResourceLoader.CACHE_MODE_REPLACE_DEEP)
	
	
	return res

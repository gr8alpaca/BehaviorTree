@tool
extends Resource

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
	resource_name = "RationalCache"
	
	assign_ids()
	
	var err: int = ResourceSaver.save(self, "cache.tres", ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)
	if err != OK:
		printerr("\t ERROR: ", error_string(err), "Could not save resource: ", self, )

func assign_ids() -> void:
	var uid: PackedInt32Array = []
	for item: Resource in cache:
		if item.resource_path and not ResourceLoader.get_resource_uid(item.resource_path):
			var id: int = ResourceUID.create_id()
			data[id] = item
			ResourceUID.set_id(id, item.resource_path)
			print_rich("UID Created: " + Ut.col(str(id), "cyan"), "\tResource: ", Ut.col(str(item), "orange"))
			

static func load_cache() -> Resource:
	if not FileAccess.file_exists("cache.gd"):
		var data: Resource = preload("cache.gd").new()
		data.save_cache()
		return data
	
	return ResourceLoader.load("cache.gd", "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)

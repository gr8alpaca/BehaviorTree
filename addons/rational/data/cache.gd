@tool
extends Resource
const LOCAL_PATH: String = "/data/cache.tres"

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
	
	var path: String = Engine.get_singleton("Rational").get_script().resource_path.get_base_dir() + LOCAL_PATH
	take_over_path(path)
	
	var err: int = ResourceSaver.save(self, path, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS)

func assign_ids() -> void:
	var uid: PackedInt32Array = []
	for item: Resource in cache:
		if item.resource_path and not ResourceLoader.get_resource_uid(item.resource_path):
			var id: int = ResourceUID.create_id()
			data[id] = item
			ResourceUID.set_id(id, item.resource_path)
			print_rich("UID Created: " + Ut.col(str(id), "cyan"), "\tResource: ", Ut.col(str(item), "orange"))
			



static func load_cache() -> Resource:
	var path: String = Engine.get_singleton("Rational").get_script().resource_path.get_base_dir() + LOCAL_PATH
	
	if not FileAccess.file_exists(path):
		if not DirAccess.dir_exists_absolute(path): 
			DirAccess.make_dir_recursive_absolute(path.get_base_dir())
		var data : Resource = Resource.new()
		data.set_script(preload("cache.gd"))
		data.save_cache()
		return data
	
	
	return ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_REPLACE_DEEP)
	
	
	

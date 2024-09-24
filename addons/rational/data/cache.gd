@tool
extends Resource

signal tree_added(tree: RationalTree)
signal tree_removed(tree: RationalTree)

signal root_added(root: Composite)
signal root_removed(root: Composite)

signal file_path_added(file: String)
signal file_path_moved(old_file: String, new_file: String)
signal file_path_removed(file: String)


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:RationalTree", PROPERTY_USAGE_EDITOR)
var trees: Array[RationalTree]


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:Composite", PROPERTY_USAGE_EDITOR)
var roots: Array[Composite]

@export
var file_paths: PackedStringArray

@export 
var save_file_string: String


@export
var save_data: PackedByteArray


#region Trees

func add_tree(tree: RationalTree) -> void:
	assert(tree != null, "Null RationalTree Node attempted to add itself to cache...")
	if tree not in trees:
		trees.push_back(tree)
		tree_added.emit(tree)
		if tree.root and tree.root not in roots:
			add_root(tree.root)


func remove_tree(tree: RationalTree) -> void:
	if tree in trees:
		trees.erase(tree)
		tree_removed.emit(tree)
		if tree.root and tree.root.resource_path.contains(".tscn"):
			add_root(tree.root)

#endregion

#region Roots

func add_root(root: RationalComponent) -> void:
	if root not in roots:
		roots.append(root)
		root_added.emit(root)


func remove_root(root: RationalComponent) -> void:
	if root in roots:
		roots.erase(root)
		root_removed.emit(root)

#endregion

#region File Paths

func add_file_path(file: String) -> void:
	if file and FileAccess.file_exists(file) and not file in file_paths:
		file_paths.push_back(file)
		file_path_added.emit(file)

func move_file_path(old_file: String, new_file: String) -> void:
	if old_file in file_paths:
		file_paths.set(file_paths.find(old_file), new_file)

func remove_file_path(file: String) -> void:
	if file in file_paths:
		file_paths.remove_at(file_paths.find(file))
		file_path_removed.emit(file)

#endregion

#region Properties

func _get_property_list() -> Array[Dictionary]:
	return [{
		name = "file_text",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_MULTILINE_TEXT,
		usage = PROPERTY_USAGE_DEFAULT,
	}]


func _get(property: StringName) -> Variant:
	if property == "file_text": 
		return save_data.get_string_from_utf8() if save_data else ""
	return null


func _set(property: StringName, value: Variant) -> bool:
	if property == "file_text":
		save_data = value.to_utf8_buffer()
		notify_property_list_changed()
		return true
	return false

#endregion
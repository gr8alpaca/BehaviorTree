@tool
extends Resource


signal tree_added(tree: RationalTree)
signal tree_removed(tree: RationalTree)

signal root_added(root: Composite)
signal root_removed(root: Composite)


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:RationalTree", PROPERTY_USAGE_EDITOR)
var trees: Array[RationalTree]


@export_custom(PROPERTY_HINT_TYPE_STRING, "24/17:Composite", PROPERTY_USAGE_EDITOR)
var roots: Array[Composite]


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


func add_root(root: RationalComponent) -> void:
	if root not in roots:
		roots.append(root)
		root_added.emit(root)


func remove_root(root: RationalComponent) -> void:
	if root in roots:
		roots.erase(root)
		root_removed.emit(root)
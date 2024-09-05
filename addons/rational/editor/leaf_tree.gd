@tool
extends Tree
const TAG: StringName = &"TreeItem"

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "RationalComponent", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var root: RationalComponent : set = set_root

var paths: Dictionary = {} # resource = tree_item

func set_root(val: RationalComponent) -> void:
	if root == val: return
	root = val
	switch_to_tree(root)

func switch_to_tree(tree_root: RationalComponent) -> void:
	clear_all()
	if not tree_root: return
	add(tree_root)
	

func add(res: RationalComponent, parent: TreeItem = null) -> void:
	var item: TreeItem = create_item(parent)
	paths[res] = item
	item.set_icon(0, load("../icons/"))
	item.set_text(0, )
	#item.set_icon(0, )
	
	



func clear_all() -> void:
	paths.clear()
	clear()

# TODO
func filter_items(txt: String) -> void:
	pass
	
func _on_filter_text_changed(new_text: String) -> void:
	filter_items(new_text)

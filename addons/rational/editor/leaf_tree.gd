@tool
extends Tree
const TAG: StringName = &"TreeItem"
const UTIL := preload("res://addons/rational/util.gd")


@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "RationalComponent", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var root: RationalComponent: set = set_root

var paths: Dictionary = {} # resource = tree_item


var icons: Dictionary = {
	# hidden = theme.get(&"EditorIcons/icons/GuiVisibilityHidden"),
	# visible = theme.get(&"EditorIcons/icons/GuiVisibilityVisible"),
}

func _ready() -> void:
	if not Engine.has_meta(&"Icons"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta [color=pink]\"Icons\"[/color]")
		return

	icons = Engine.get_meta(&"Icons", {})
	

func switch_to_tree(tree_root: RationalComponent) -> void:
	clear_all()
	if not tree_root: return
	add(tree_root)
	

func add(res: RationalComponent, parent: TreeItem = null) -> void:
	
	var item: TreeItem = create_item(parent)
	item.coll
	bind(res, item)
	

func bind(res: Resource, item: TreeItem) -> void:
	paths[res] = item
	item.set_metadata(0, res)
	item.set_icon(0, icons.get(res.get_class(), UTIL.get_invalid_icon()))
	

# TODO get_column_expand_ratio
func filter_items(txt: String) -> void:
	pass
	

func clear_all() -> void:
	paths.clear()
	clear()

func set_item_visible(item: TreeItem, item_visible: bool) -> void:
	var button_id: int = item.get_button_count(1) - 1

	item.set_metadata(1, item_visible)

	if item_visible:
		item.set_button(1, button_id, theme.get(&"EditorIcons/icons/GuiVisibilityVisible"))
	else:
		item.set_button(1, button_id, theme.get(&"EditorIcons/icons/GuiVisibilityHidden"))
	
	# item.visible = val


func set_root(val: RationalComponent) -> void:
	if root == val: return
	root = val
	switch_to_tree(root)


func _on_filter_text_changed(new_text: String) -> void:
	filter_items(new_text)


func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	item.set_metadata(1, !item.get_metadata(1))
	# set_item_visible(item, item.get_metadata(1))
	
	# if item.get_metadata(1):
	# 	item.set_button(column, id, theme.get(&"EditorIcons/icons/GuiVisibilityVisible"))
	# else:
	# 	item.set_button(column, id, theme.get(&"EditorIcons/icons/GuiVisibilityHidden"))

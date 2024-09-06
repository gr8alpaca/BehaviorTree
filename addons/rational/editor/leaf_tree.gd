@tool
extends Tree
const TAG: StringName = &"TreeItem"
const UTIL := preload("res://addons/rational/util.gd")

const COLUMN_INDEX: int = 0
@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "RationalComponent", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var root: RationalComponent: set = set_root

var paths: Dictionary = {} # resource = tree_item

var icons: Dictionary = {}


func _ready() -> void:
	theme = EditorInterface.get_editor_theme()
	
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
	bind(res, item)
	item.set_editable(COLUMN_INDEX, false)
	
	#item.set_cell_mode(COLUMN_INDEX, TreeItem.CELL_MODE_STRING)
	
	#item.set_icon_region(0, Rect2(Vector2.ZERO, Vector2(16,16)*EditorInterface.get_editor_scale()))
	
	#item.set_expand_right()
	#item.set_cell_mode(1, TreeItem.CELL_MODE_STRING)
	#item.set_text_alignment(COLUMN_INDEX, HORIZONTAL_ALIGNMENT_LEFT)

	var button_id: int = item.get_button_count(COLUMN_INDEX)
	item.add_button(COLUMN_INDEX, get_theme_icon(&"GuiVisibilityVisible", &"EditorIcon"), button_id, false, "Make tree item visible")
	item.set_metadata(COLUMN_INDEX, true)

func bind(res: Resource, item: TreeItem) -> void:
	paths[res] = item
	item.set_metadata(0, res)
	item.set_icon(0, icons.get(res.get_class(), UTIL.invalid_icon()))
	item.set_text(COLUMN_INDEX, "Test Item String")


func filter_items(txt: String) -> void:
	pass
	

func clear_all() -> void:
	paths.clear()
	clear()


func set_item_visible(item: TreeItem, item_visible: bool) -> void:
	item.set_metadata(0, item_visible)
	
	if item_visible: 
		item.set_button(0, item.get_button_count(0) - 1, get_theme_icon(&"GuiVisibilityVisible", &"EditorIcon"))
	
	else: 
		item.set_button(0, item.get_button_count(0) - 1, get_theme_icon(&"GuiVisibilityHidden", &"EditorIcon"))
	
	

func set_root(val: RationalComponent) -> void:
	if root == val: return
	root = val
	switch_to_tree(root)


func _on_filter_text_changed(new_text: String) -> void:
	filter_items(new_text)


func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	set_item_visible(item, !item.get_metadata(0))


func _on_refresh_list_button_pressed() -> void:
	pass # Replace with function body.

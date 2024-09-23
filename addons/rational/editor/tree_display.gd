@tool
extends Tree
const TAG: StringName = &"TreeItem"
const Util := preload("res://addons/rational/util.gd")

const COLUMN_INDEX: int = 0

@export_custom(PROPERTY_HINT_RESOURCE_TYPE, "RationalComponent", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY)
var root: RationalComponent

var paths: Dictionary

var icons: Dictionary

func _ready() -> void:
	var theme: Theme = EditorInterface.get_editor_theme()
	icons = {
		hidden = theme.get_icon(&"GuiVisibilityHidden", &"EditorIcons"),
		visible = theme.get_icon(&"GuiVisibilityVisible", &"EditorIcons"),
		invalid = theme.get_icon(&"MissingResource", &"EditorIcons"),
		}

	if Engine.has_meta(&"Main"):
		Engine.get_meta(&"Main").edit_tree_pressed.connect(_on_edit_tree_pressed, CONNECT_DEFERRED)
	

func _on_edit_tree_pressed(tree: RationalTree) -> void:
	if not tree: return
	if not tree.root:
		tree.root = Sequence.new()

	switch_to_tree(tree.root)
	

func switch_to_tree(tree_root: RationalComponent) -> void:
	clear_all()
	root = tree_root
	if not root: return
	
	add_component(root)
	

func add_component(res: RationalComponent, parent: TreeItem = null) -> void:
	var item: TreeItem = create_item(parent)
	bind(res, item)
	item.set_editable(0, false)
	
	item.add_button(0, get_theme_icon(&"GuiVisibilityVisible", &"EditorIcons"), item.get_button_count(0), false, "Make tree item visible")

	for child: RationalComponent in res.get_children():
		add_component(child, item)
	

func bind(res: RationalComponent, item: TreeItem) -> void:
	item.set_metadata(0, res)
	item.set_icon(0, get_icon(res.get_class_name()))
	item.set_text(0, get_unique_name(res))


func get_unique_name(res: RationalComponent) -> String:
	if res == get_root().get_metadata(0): return res.resource_name
	var unique_name: String = res.get_class_name().back()
	var name_count: int = 0
	for item: TreeItem in get_tree_items():
		if item.get_metadata(0) == res: continue
		if item.get_text(0).containsn(unique_name):
			name_count += 1
	if name_count:
		unique_name += str(name_count)
	return unique_name


func get_tree_items(item: TreeItem = get_root()) -> Array[TreeItem]:
	if not item: return []
	var items: Array[TreeItem] = [item]
	for child: TreeItem in item.get_children():
		items += get_tree_items(child)
	return items


func filter_items(txt: String) -> void:
	pass
	

func clear_all() -> void:
	paths.clear()
	clear()


func set_item_visible(item: TreeItem, item_visible: bool) -> void:
	item.set_metadata(0, item_visible)
	
	if item_visible:
		item.set_button(0, item.get_button_count(0) - 1, get_theme_icon(&"GuiVisibilityVisible", &"EditorIcons"))
	
	else:
		item.set_button(0, item.get_button_count(0) - 1, get_theme_icon(&"GuiVisibilityHidden", &"EditorIcons"))
	

func get_icon(class_names: Array[StringName]) -> Texture2D:
	return icons.get_or_add(class_names.back(), Util.get_class_icon(class_names))


func _on_filter_text_changed(new_text: String) -> void:
	filter_items(new_text)


func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	set_item_visible(item, item.get_button(column,id) == get_theme_icon(&"GuiVisibilityHidden", &"EditorIcons"))


func _on_refresh_list_button_pressed() -> void:
	if root: switch_to_tree(root)


## Connected to item list signal.
func _on_root_selected(root: Composite) -> void:
	pass # Replace with function body.

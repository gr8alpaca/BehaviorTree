@tool
extends ItemList

const Util := preload("res://addons/rational/util.gd")

signal root_selected(root: RationalComponent)


var cache: Resource


func _ready() -> void:
	if not Engine.has_meta(&"Cache"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta [color=pink]\"Cache\"[/color]")
		return

	cache = Engine.get_meta(&"Cache")

	cache.root_added.connect(_on_root_added)
	cache.root_removed.connect(_on_root_removed)

	fixed_icon_size = Vector2(16, 16) * EditorInterface.get_editor_scale()

	if Engine.has_meta(&"Main"):
		Engine.get_meta(&"Main").edit_tree_pressed.connect(_on_edit_tree_pressed)
	
	
	build_list()
	item_activated.connect(_on_item_activated)


func build_list() -> void:
	clear()

	for root: RationalComponent in cache.roots:
		create_item(root)
	sort_items_by_text()


func _on_edit_tree_pressed(tree: RationalTree) -> void:
	if not tree.root: return
	

	if not is_in_list(tree.root):
		create_item(tree.root)


	select(get_item_index(tree.root))
	ensure_current_is_visible()


func create_item(root: RationalComponent) -> void:
	root.resource_name = root.resource_name if root.resource_name else root.get_class_name()
	var index: int = add_item(root.resource_name, Util.get_class_icon(root.get_class_name()))
	update_item_display(index, root)
	root.changed.connect(_on_root_changed.bind(root))


func update_item_display(index: int, root: RationalComponent) -> void:
	set_item_metadata(index, root)
	set_item_tooltip(index, get_root_tooltip(root))


func erase_item(root: RationalComponent) -> void:
	if not is_in_list(root): return
	var index: int = get_item_index(root)
	remove_item(index)
	

func filter_list(filter: String = "") -> void:
	for root: RationalComponent in cache.roots:
		match [is_in_list(root), root.resource_name.containsn(filter)]:
			[true, false]:
				remove_item(get_item_index(root))
			[false, true]:
				create_item(root)
				sort_items_by_text()


func get_root_tooltip(root: RationalComponent) -> String:
	var tree_name: StringName = root.get_meta(&"RationalTree").name if root.has_meta(&"RationalTree") else "none"
	return "Tree: %s\nType: %s\nPath: %s" % [tree_name, root.get_class_name().back(), root.resource_path]


## Returns index of item binded to [param root] or [code]-1[/code]
func get_item_index(root: RationalComponent) -> int:
	for index: int in item_count:
		if get_item_metadata(index) == root:
			return index
	return -1


## Returns true or false if item is in list.
func is_in_list(root: RationalComponent) -> bool:
	return get_item_index(root) != -1

func _on_root_changed(root: RationalComponent) -> void:
	update_item_display(get_item_index(root), root)

func _on_root_added(root: RationalComponent) -> void:
	create_item(root)

func _on_root_removed(root: RationalComponent) -> void:
	erase_item(root)

func _on_filter_text_changed(new_text: String) -> void:
	filter_list(new_text)


func _on_item_activated(index: int) -> void:
	ensure_current_is_visible()
	root_selected.emit(get_item_metadata(index))


func _on_add_root_button_pressed() -> void:
	
	pass


func create_root(res: RationalComponent) -> void:
	pass


#region Drag&Drop


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	match typeof(data):
		TYPE_INT:
			return data > -1
		TYPE_OBJECT:
			return data is RationalComponent
		TYPE_STRING:
			return data and (data.contains(".tscn") or data.contains(".tres"))

		_:
			return false

	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	match typeof(data):
		# Moves item if the dropped rational component is already in list
		TYPE_INT:
			move_item(data, get_item_at_position(at_position, false))

		TYPE_OBJECT when data is RationalComponent:
			create_item(data)
			
		TYPE_STRING:
			pass


		


func _get_drag_data(at_position: Vector2) -> Variant:
	var item: int = get_item_at_position(at_position, true)
	if item > -1:
		var button: Button = Button.new()
		button.text = get_item_text(item)
		button.icon = get_item_icon(item)
		button.modulate.a = 0.65
		set_drag_preview(button)

	return item


#endregion 


#


#

## Creates unique name and changes root [code]resource_name[/code] to it
func get_unique_root_name(root: RationalComponent) -> String:
	var root_name: String = root.resource_name if root.resource_name else root.get_class_name()
	root.resource_name = root_name
	return root_name

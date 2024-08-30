@tool
class_name RationalEditor extends PanelContainer
const GROUP: StringName = &"RationalEditor"

var hsplit: HSplitContainer = HSplitContainer.new()
#var hsplit_sub: HSplitContainer = HSplitContainer.new()

var item_list: ItemList = ItemList.new()
var message: Label = Label.new()

func _ready() -> void:
	add_child(hsplit)
	hsplit.add_child(item_list)
	
	item_list.custom_minimum_size = Vector2(40, 0)
	item_list.item_selected.connect(_on_item_selected)
	
	
func _on_item_selected(idx: int) -> void:
	pass

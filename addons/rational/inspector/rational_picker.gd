@tool
extends Button

func _ready() -> void:
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	text = "Add children from script..."
	icon = preload("../editor/icons/Load.svg")
	


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is GDScript or data is RationalComponent: return true
	return false

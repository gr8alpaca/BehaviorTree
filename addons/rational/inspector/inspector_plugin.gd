@tool
extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is Composite

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if type == TYPE_OBJECT and hint_string == "RationalComponent":
		pass
	
	return false

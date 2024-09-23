@icon("../icons/Fallback.svg")
@tool
class_name Fallback extends Composite



func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"Fallback")
	return names

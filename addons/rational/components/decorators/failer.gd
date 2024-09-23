@icon("../../icons/StatusError.svg")
@tool
class_name Failer extends Decorator

func modify_response(response: int) -> int:
	return FAILURE


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"Failer")
	return names

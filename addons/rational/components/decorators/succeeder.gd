@icon("../../icons/StatusSuccess.svg")
@tool
class_name Succeeder extends Decorator


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"Succeeder")
	return names


func modify_response(response: int) -> int:
	return SUCCESS
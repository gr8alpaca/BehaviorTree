@icon("../../icons/StatusError.svg")
@tool
class_name Failer extends Decorator

func modify_response(response: int) -> int:
	return FAILURE
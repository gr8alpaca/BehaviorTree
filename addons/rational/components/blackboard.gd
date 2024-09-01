class_name Blackboard extends Resource


@export var data: Dictionary = {}


func keys() -> Array[String]:
	return Array(data.keys().duplicate(), TYPE_STRING, "", null)
	
func values() -> Array:
	return data.values()

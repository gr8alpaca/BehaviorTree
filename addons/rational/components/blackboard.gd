@tool
@icon("../icons/Blackboard.svg")
class_name Blackboard extends Resource


## Use [method has], [method SET], and [method GET] to access.
@export var data: Dictionary = {}: set = set_board_data


func GET(key: String, default: Variant) -> Variant:
	return data.get(key, default)


func SET(key: String, val: Variant) -> void:
	data[key] = val


func has(key: String) -> bool:
	return data.has(key)


func erase(key: String) -> bool:
	if not has(key): return false
	data.erase(key)
	return true
	

func keys() -> Array[String]:
	return Array(data.keys().duplicate(), TYPE_STRING, "", null)
func values() -> Array:
	return data.values()


func set_board_data(val: Dictionary) -> void:
	data = val


# # To be removed

func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []
	for key: String in keys():
		props.append \
		(
			{
				name = key,
				type = typeof(data[key]),
				usage = PROPERTY_USAGE_EDITOR,
			}
		)

	return props


func _set(property: StringName, value: Variant) -> bool:
	match property:
		"resource_path", "resource_name", "resource_local_to_scene":
			pass
		_:
			data[property] = value
			
	return false
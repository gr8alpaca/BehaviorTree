@tool
extends ResourceFormatSaver


func _recognize_path(resource: Resource, path: String) -> bool:
	return false


func _save(resource: Resource, path: String, flags: int) -> Error:
	if not resource:
		printerr("Cannot save <null> resource (rational_saver.gd)") 
		return ERR_INVALID_PARAMETER

	
	path = resource.resource_path if not path else path

	if not path or not path.is_valid_filename():
		printerr("Save path null or invalid")
		return ERR_INVALID_PARAMETER



	if flags < 0:
		printerr("Invalid SaveFlags < 0 (rational_saver.gd)")
		flags = 0


	
	return OK

	

func _set_uid(path: String, uid: int) -> Error:
	return OK


func _recognize(resource: Resource) -> bool:
	return resource is RationalComponent

func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
	return PackedStringArray(["rational", "tres", "res", "gd"])


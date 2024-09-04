class_name RationalSaver extends ResourceFormatSaver

# var root_data: Dictionary = {

#     # path<String> = {
#     #   "uid" = <uid_string>
#     #
#     #   }
# }
var can_recognize_packed: bool = true

func _recognize(resource: Resource) -> bool:
	return resource is RationalComponent or (resource is PackedScene and can_recognize_packed)


func _get_recognized_extensions(resource: Resource) -> PackedStringArray:
	return [".tres"] if resource is RationalComponent else [".tscn"]


# func _set_uid(path: String, uid: int) -> Error:
#     return OK


func _save(resource: Resource, path: String, flags: int) -> Error:
	print("RationalSaver called...\nResource: [color=pink]%s[/color]\tType: [color=pink]%s[/color]\tPath: [color=pink]%s[/color]\tFlags: [color=pink]%s[/color]" % [resource, resource.get_class(), path, flags])


	if resource is PackedScene:
		for v: Variant in resource._bundled.get("variants", []):
			if v is RationalComponent and v.resource_path.get_extension() != "tres":
				v.resource_path = "res://addons/rational/data/" + v.get_class() + path.split("::")[-1]
				ResourceSaver.save(v, v.resource_path, ResourceSaver.FLAG_NONE)
				
		can_recognize_packed = false
		var err: Error = ResourceSaver.save(resource, path, flags)
		can_recognize_packed = true

	if not (resource is RationalComponent):
		var message: String = "Attempting to save resource that does not inheret RationalComponent!\nResource: %s\tPath: %s\tFlags: %s" % [resource, path, flags]
		push_warning(message)
		print_debug(message)


	# if not ResourceLoader.get_resource_uid(path):
	#     var new_uid: int = ResourceUID.create_id()
	#     ResourceUID.set_id(new_uid, path)
	# assert(resource is RationalComponent)

	return OK

@tool
extends ItemList

@export_storage var active_paths: PackedStringArray = PackedStringArray()

#var data: Array[Dictionary] = []
var data: Dictionary = {}
#
#{
#	resource = <Resource>,
#	path = resource.get_path(),
#	
#
#}


func _ready() -> void:
	if not Engine.has_meta(&"Cache"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta [color=pink]\"Cache\"[/color]")
		return
	var cache_resource: Resource = Engine.get_meta(&"Cache")
	cache_resource.added.connect(_on_added)
	cache_resource.removed.connect(_on_removed)
	
func reload_state() -> void:
	if not Engine.has_meta(&"Cache"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta [color=pink]\"Cache\"[/color]")
		return
	
	for root: RationalComponent in get_cache():
		pass


func create_item(root: Root) -> void:
	pass


func filter_items(filter: String) -> void:
	pass

func _on_added(res: Root) -> void:
	pass
	
func _on_removed(res: Root) -> void:
	pass
	
func _on_filter_text_changed(new_text: String) -> void:
	filter_items(new_text)

func get_cache() -> Array[Resource]:
	if not Engine.has_meta(&"Cache"):
		print_rich("[color=red]ERROR[/color]: Engine does not have meta [color=pink]\"Cache\"[/color]")
		return []
		
	return Engine.get_meta(&"Cache").cache

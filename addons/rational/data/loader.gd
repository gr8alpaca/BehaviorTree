class_name RationalLoader extends ResourceFormatLoader


func initialize_cache() -> void:
    pass
    
func _handles_type(type: StringName) -> bool:
    return false

func _load(path: String, original_path: String, use_sub_threads: bool, cache_mode: int) -> Variant:
    return ERR_BUG

# set_abort_on_missing_resources
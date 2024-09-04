@tool
@icon("res://addons/rational/icons/NewRoot.svg")
class_name Root extends Decorator


@export var tree_name: String = "":
    set(val):
        tree_name = val
        changed.emit()


# func _get_property_list() -> Array[Dictionary]:
#     var props:= super._get_property_list()
#     props[0]["hint_string"] = "Root"
#     return props


func _notification(what: int) -> void:
    if not Engine.is_editor_hint(): return

    match what:
        
        NOTIFICATION_POSTINITIALIZE:
            pass
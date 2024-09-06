@tool
@icon("res://addons/rational/icons/NewRoot.svg")
class_name Root extends Decorator

@export var tree_name: String:
	set(val):
		tree_name = val
		changed.emit()

func _notification(what: int) -> void:
	if not Engine.is_editor_hint(): return

	match what:
		
		NOTIFICATION_POSTINITIALIZE:
			pass
		NOTIFICATION_PREDELETE:
			pass

@tool
@icon("res://addons/rational/icons/NewRoot.svg")
class_name Root extends Decorator

@export var tree_name: String:
	set(val):
		tree_name = val
		changed.emit()



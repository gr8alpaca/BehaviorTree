@tool
@icon("../icons/ActionLeaf.svg")
class_name ActionLeaf extends Leaf

func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"ActionLeaf")
	return names

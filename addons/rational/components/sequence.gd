@tool
@icon("../icons/Sequence.svg")
class_name Sequence extends Composite

func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	for child: RationalComponent in children:
		var status: int = child.tick(delta, board, actor)
		if status != SUCCESS: return status

	return SUCCESS


func get_class_name() -> Array[StringName]:
	var names: Array[StringName] = super()
	names.push_back(&"Sequence")
	return names
@tool
@icon("../icons/ActionLeaf.svg")
class_name ActionLeaf extends Leaf

func _tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS

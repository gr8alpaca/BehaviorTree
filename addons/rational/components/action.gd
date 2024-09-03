@tool
@icon("../icons/Action.svg")
class_name ActionLeaf extends Leaf

func tick(delta: float, board: Blackboard, actor: Node) -> int:
	return SUCCESS

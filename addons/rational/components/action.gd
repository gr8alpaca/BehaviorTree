@icon("../icons/Action.svg")
@tool
class_name ActionLeaf extends Leaf


func tick(delta: float, board: Blackboard, actor: Node) -> int: 
    return FAILURE
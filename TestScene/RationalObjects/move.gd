@tool
class_name MoveAction extends ActionLeaf

@export var target_global_position: Vector2
@export var speed: float = 50.0

func tick(delta: float, board: Blackboard, actor: Node) -> int:
	actor.global_position.move_toward(target_global_position, speed)
	
	if actor.global_position == target_global_position:
		return SUCCESS
	else:
		return RUNNING
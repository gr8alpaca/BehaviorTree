@tool
enum {SUCCESS, FAILURE, RUNNING}

static func tick_static(delta: float, board: Blackboard, actor: Node, data: Dictionary = {}) -> int:
    return SUCCESS

static func get_export_properties() -> Dictionary:
    return {}
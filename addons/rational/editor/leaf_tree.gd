@tool
extends Tree

func _ready() -> void:
	var plugin: EditorPlugin = Engine.get_singleton(&"Rational")
	plugin.scene_changed.connect(_on_scene_changed)

func _on_scene_changed(node: Node) -> void:
	pass
#func search_node_and_children(node: Node)

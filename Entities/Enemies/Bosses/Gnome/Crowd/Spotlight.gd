extends Node2D

export var targetPath: NodePath
var targetNode: Node2D

func _ready() -> void:
	if targetPath:
		targetNode = get_node(targetPath)
		return
	targetNode = GameManager.player


func _process(delta: float) -> void:
	look_at(targetNode.global_position)

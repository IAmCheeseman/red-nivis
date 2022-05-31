extends Node2D

export var targetPath: NodePath
var targetNode: Node2D

func _ready() -> void:
	if targetPath:
		targetNode = get_node(targetPath)
		return
	targetNode = GameManager.player


func _process(delta: float) -> void:
	if !is_instance_valid(targetNode): targetNode = GameManager.player
	var oldRot = rotation
	look_at(targetNode.global_position)
	rotation = lerp(oldRot, rotation, 15 * delta)

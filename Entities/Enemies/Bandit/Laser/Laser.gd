extends Node2D

onready var sprite = $Sprite

var player: Node2D

const ARM_POSITIONS := [Vector2(3, -13), Vector2(-3, -13)]

var prevRot := 0.0


func _process(delta: float) -> void:
	if !player: return
	
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	position = ARM_POSITIONS[int(sprite.flip_v)]
	position.x *= get_parent().sprite.scale.x
	
	var weight = 10 * delta
	weight *= global_position.distance_to(player.global_position) / 50
	global_rotation = lerp_angle(prevRot, global_rotation, weight)
	
	prevRot = global_rotation

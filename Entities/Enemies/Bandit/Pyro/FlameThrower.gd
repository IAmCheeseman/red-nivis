extends Node2D

onready var sprite = $Sprite

var player: Node2D

const ARM_POSITIONS := [Vector2(-3, -9), Vector2(3, -4)]

onready var damager = $Damager

export var DMGRange := 65

var prevRot := 0.0


func _process(delta: float) -> void:
	if !player: return
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	position = ARM_POSITIONS[int(sprite.flip_v)]
	position.x *= get_parent().sprite.scale.x
	
	#damager.cast_to = Vector2.RIGHT * DMGRange
	var weight = 10 * delta
	weight *= global_position.distance_to(player.global_position) / 100
	damager.global_rotation = lerp_angle(prevRot, rotation, weight)
	
	prevRot = damager.global_rotation

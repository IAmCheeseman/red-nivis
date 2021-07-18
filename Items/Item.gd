extends Node2D

onready var flipPos = $FlipPos
onready var sprite = $Sprite


func _physics_process(delta):
	# Flipping the gun based on rotation
	var local = flipPos.global_position-global_position
	if local.x < 0:
		sprite.scale.y = -1
	else:
		sprite.scale.y = 1
	# Showing the gun behind the parent based on rotation
	show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = sprite.global_rotation
	look_at(get_global_mouse_position())
	var targetRot = global_rotation

	sprite.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the gun down after it's been kicked up
	sprite.rotation = lerp_angle(sprite.rotation, 0, 4*delta)

extends Node


var player:Node2D
var rc := RayCast2D.new()

var playerData = preload("res://Entities/Player/Player.tres")
var dashParticles = preload("res://Entities/Player/Assets/Dash.tscn")


func _ready() -> void:
	add_child(rc)
	rc.enabled = true

func _input(_event: InputEvent) -> void:
	# Dashing
	if Input.is_action_just_pressed("dash") and playerData.dashesLeft > 0:
		var dashDir = Vector2.ZERO
		dashDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		dashDir.y = Input.get_action_strength("down")
		dashDir = dashDir.normalized()*64
		
		rc.global_position = player.global_position+(Vector2.UP*8)
		rc.cast_to = dashDir.normalized()*70
		rc.force_raycast_update()
		if rc.is_colliding():
			dashDir = rc.get_collision_point()-player.position
		
		player.position += dashDir
		playerData.dashesLeft -= 1
		player.dashCooldown.start()

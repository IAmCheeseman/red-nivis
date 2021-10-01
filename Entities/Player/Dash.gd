extends Node


onready var parent:Node2D = get_parent().get_parent()

var playerData = preload("res://Entities/Player/Player.tres")
var dashParticles = preload("res://Entities/Player/Assets/Dash.tscn")


func _input(_event: InputEvent) -> void:
	# Dashing
	if Input.is_action_just_pressed("dash") and playerData.dashesLeft > 0:
		var dashDir = Vector2.ZERO
		dashDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		dashDir.y = Input.get_action_strength("down")
		dashDir.normalized()
		dashDir *= playerData.dashSpeed
		
		dashDir.y = clamp(dashDir.y, -playerData.jumpForce, INF)
		
		if dashDir == Vector2.ZERO:
			return
		
		parent.vel = dashDir
		
		parent.state = parent.states.DASH
		playerData.dashesLeft -= 1
		parent.dashCooldown.start()
		
		parent.SaS.play("Dash")
		
		var newDashPar = dashParticles.instance()
		parent.sprite.add_child(newDashPar)
		newDashPar.emitting = true
		parent.jumpSFX.play()

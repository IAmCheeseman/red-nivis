extends Node


var player:Node2D
var rc := RayCast2D.new()

var playerData = preload("res://Entities/Player/Player.tres")
var teleParticles = preload("res://Entities/Player/Assets/Dash.tscn")


func _ready() -> void:
	add_child(rc)
	rc.enabled = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash") and playerData.dashesLeft > 0 and !player.lockMovement:
		var dashDir := Vector2.ZERO
		dashDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		dashDir.y = Input.get_action_strength("down")
		dashDir = dashDir.normalized()*64
		
		for i in 3:
			rc.global_position = player.global_position+(
				Vector2.UP*(8*i)
			)
			rc.cast_to = dashDir.normalized()*70
			rc.force_raycast_update()
			if rc.is_colliding():
				var collisionPoint = player.to_local(rc.get_collision_point())
				var evenPoint = Vector2(collisionPoint.x, 0)
				
				if evenPoint.distance_to(Vector2.ZERO) < dashDir.distance_to(Vector2.ZERO):
					dashDir = evenPoint
		if dashDir.length() < 16: return
		
		var pos = [player.position, player.position+dashDir]
		for i in pos:
			var newPatricles = teleParticles.instance()
			newPatricles.position = i-Vector2(0, 8)
			GameManager.spawnManager.spawn_object(newPatricles)
		
		
		player.position += dashDir
		player.vel.y = 0
		playerData.dashesLeft -= 1
		player.dashCooldown.start()
		

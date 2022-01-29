extends Node


var player:Node2D
var rc := RayCast2D.new()
var sfx := preload("res://Managing/SoundManager.tscn").instance()
var canDash := true

var playerData = preload("res://Entities/Player/Player.tres")
var teleParticles = preload("res://Entities/Player/Assets/Dash.tscn")


func _ready() -> void:
	add_child(rc)
	rc.enabled = true
	add_child(sfx)
	sfx.audio = preload("res://Items/Upgrades/Teleport/Dash.wav")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash") and playerData.dashesLeft > 0 and !player.lockMovement and canDash:
		var dashDir := Vector2.ZERO
		dashDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		dashDir = dashDir.normalized()*playerData.dashSpeed
		if dashDir == Vector2.ZERO: return
		canDash = false
		
		var newDashParticles = teleParticles.instance()
		newDashParticles.position.y = -8
		newDashParticles.emitting = true
		player.add_child(newDashParticles)
		
		var timer = get_tree().create_timer(.2)
		timer.connect("timeout", newDashParticles, "queue_free")
		
		var cooldown = get_tree().create_timer(.7)
		cooldown.connect("timeout", self, "set", ["canDash", true])
		
		player.state = player.states.DASH
		player.scaleHelper.scale = Vector2(1.5, .5)
		player.vel = dashDir
		player.vel.y = 0
		playerData.dashesLeft -= 1
		player.dashCooldown.start()
		
		sfx.play()

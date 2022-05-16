extends Node2D


const PLAYER = preload("res://Entities/Player/Player.tres")

onready var sprite = $Sprite
onready var particles = $Sprite/Fire


func _process(delta: float) -> void:
	var player = PLAYER.playerObject
	
	particles.emitting = false
	if !player.is_grounded() and Input.is_action_pressed("jump") and player.vel.y > -PLAYER.jumpForce * .1:
			player.vel.y -= (Globals.GRAVITY * delta) * .95
			player.vel.y = clamp(player.vel.y, -INF, Globals.GRAVITY * .05)
			particles.emitting = true
			
			player.scaleHelper.scale = player.scaleHelper.scale / player.scaleHelper.scale
	
	sprite.scale = player.scaleHelper.scale * player.sprite.scale
	global_position = player.global_position

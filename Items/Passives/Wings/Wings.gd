extends Node2D


const PLAYER = preload("res://Entities/Player/Player.tres")

onready var sprite = $Sprite
onready var anim = $AnimationPlayer


func _process(delta: float) -> void:
	var player = PLAYER.playerObject
	
	player.vel.y -= (Globals.GRAVITY * delta) / 4
	
	if player.is_grounded():
		anim.play("Idle")
	else:
		anim.play("Flap")
		player.scaleHelper.scale = player.scaleHelper.scale / player.scaleHelper.scale
	
	sprite.scale = player.scaleHelper.scale * player.sprite.scale
	global_position = player.global_position

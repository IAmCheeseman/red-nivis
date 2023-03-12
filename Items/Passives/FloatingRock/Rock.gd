extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")
var percentage = 0
var targetPos = Vector2.ZERO


func _process(delta: float) -> void:
	percentage += delta / 2
	
	targetPos = PLAYER.playerObject.global_position
	targetPos += Vector2.RIGHT.rotated(TAU * percentage) * 32
	targetPos -= Vector2(0, 8)
	
	position = position.move_toward(targetPos, 500 * delta)

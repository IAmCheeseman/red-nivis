extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")

func _ready() -> void:
	var rock = preload("res://Items/Passives/FloatingRock/Rock.tscn").instance()
	yield(TempTimer.idle_frame(self), "timeout")
	rock.player = PLAYER
	GameManager.spawnManager.spawn_object(rock)

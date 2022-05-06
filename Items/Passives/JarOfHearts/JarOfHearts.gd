extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	PLAYER.playerObject.hurtbox.connect("hurt", self, "_on_hp_changed")
	_on_hp_changed(0, Vector2.ZERO)

func _on_hp_changed(amt, _kbDir: Vector2) -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	
	PLAYER.immune = rand_range(0, 1) < 0.3

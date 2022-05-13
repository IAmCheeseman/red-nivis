extends Node2D


const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	PLAYER.playerObject.sprite.texture = preload("res://Entities/Player/Assets/BoxPlayer.png")


func _process(delta: float) -> void:
	for i in PLAYER.playerObject.sprite.get_children():
		i.hide()

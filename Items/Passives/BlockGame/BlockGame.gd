extends Node2D

const BOOST = 0.30
const PLAYER = preload("res://Entities/Player/Player.tres")

var addedBoost = false

func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var player = PLAYER.playerObject
	
	player.connect("just_landed", self, "_on_landed")

func _process(delta: float) -> void:
	var player = PLAYER.playerObject
	if player.vel.y > 0 and !player.is_grounded() and !addedBoost:
		PLAYER.damageMod += BOOST
		addedBoost = true

func _on_landed() -> void:
	PLAYER.damageMod -= BOOST
	addedBoost = false

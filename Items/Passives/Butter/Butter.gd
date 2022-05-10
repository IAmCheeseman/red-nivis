extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")

var boostApplied := false

func _ready() -> void:
	if !get_meta("used"):
		PLAYER.frictMod = clamp(
			PLAYER.frictMod * .1,
			PLAYER.minFrict, INF
		)


func _process(_delta: float) -> void:
	var player := PLAYER.playerObject
	
	var minVel := 10.0
	
	if abs(player.vel.x) > minVel and !boostApplied:
		PLAYER.damageMod += .2
		boostApplied = true
	elif abs(player.vel.x) < minVel and boostApplied:
		PLAYER.damageMod -= .2
		boostApplied = false

extends Node2D


const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "increase_ammo")
	
	if !get_meta("used"):
		PLAYER.speedMod += .1
		PLAYER.healMod = clamp(PLAYER.healMod - .1, PLAYER.healModMin, INF)
	
	inc_gun()


func inc_gun() -> void:
	var gun = PLAYER.playerObject.itemHolder.get_child(0)
	PLAYER.maxAmmo += int(ceil(float(PLAYER.maxAmmo) * .1))
	
	gun.cooldown -= gun.cooldown * .10
	gun.accuracy *= .8
	gun.projScale *= 1.2
	gun.recoil *= 0.9

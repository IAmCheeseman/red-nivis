extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "increase_ammo")
	
	increase_ammo()


func increase_ammo() -> void:
	PLAYER.maxAmmo += int(ceil(float(PLAYER.maxAmmo) * .2))

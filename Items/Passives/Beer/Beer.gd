extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "set_stats")
	
	set_stats()
	
	if !get_meta("used"):
		PLAYER.frictMod -= PLAYER.frictMod * 0.5
		PLAYER.damageMod += .333


func set_stats() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var player = PLAYER.playerObject
	var weapon = player.itemHolder.get_child(0)
	weapon.accuracy *= 2
	

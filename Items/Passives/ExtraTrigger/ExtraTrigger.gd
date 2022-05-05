extends Node2D
class_name ExtraTrigger

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "apply_effect")
	
	apply_effect()


func apply_effect() -> void:
	# :) References
	var player = PLAYER.playerObject
	var weapon = player.itemHolder.get_child(0)
	
	weapon.cooldown -= weapon.cooldown * .20

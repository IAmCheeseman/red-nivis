extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")

var damageMod := 0.0

func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "init_gun")
	
	init_gun()


func init_gun() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var gun = PLAYER.playerObject.itemHolder.get_child(0).get_node("GunLogic")
	gun.connect("bullet_hit_enemy", self, "_on_bullet_hit_enemy")
	gun.connect("bullet_hit_wall", self, "_on_bullet_hit_wall")


func _on_bullet_hit_enemy(_bullet: Node2D) -> void:
	if damageMod >= 0.5: return
	
	var increase := .1
	damageMod += increase
	PLAYER.damageMod += increase


func _on_bullet_hit_wall(_bullet: Node2D) -> void:
	_on_timeout()


func _exit_tree() -> void:
	PLAYER.damageMod -= damageMod


func _on_timeout() -> void:
	PLAYER.damageMod -= damageMod
	damageMod = 0

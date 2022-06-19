extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "init_gun")
	
	init_gun()


func init_gun() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	PLAYER.playerObject.itemHolder.get_child(0).get_node("GunLogic")\
		.connect("bullet_hit_enemy", self, "_on_bullet_hit_enemy")


func _on_bullet_hit_enemy(bullet: Node2D) -> void:
	var newBullet := bullet.duplicate()
	var dir = Vector2.RIGHT.rotated(rand_range(0, PI * 2))
	newBullet.direction = dir
	newBullet.speed = 100
	newBullet.damage = bullet.damage / 2
	GameManager.spawnManager.spawn_object(newBullet)
	yield(TempTimer.idle_frame(self), "timeout")
	newBullet.global_position += dir * 16

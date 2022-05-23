extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var _discard = PLAYER.playerObject.get_node("ItemManagement")\
		.connect("itemsChanged", self, "init_gun")
	
	init_gun()


func init_gun() -> void:
	PLAYER.playerObject.itemHolder.get_child(0).get_node("GunLogic")\
		.connect("bullet_hit_enemy", self, "_on_bullet_hit_enemy")


func _on_bullet_hit_enemy(bullet: Node2D) -> void:
	var newExplosion = preload("res://Entities/Enemies/Explosion/Explosion.tscn").instance()
	newExplosion.global_position = bullet.global_position
	newExplosion.damage = bullet.damage * 1.2
	GameManager.spawnManager.spawn_object(newExplosion) 
	yield(TempTimer.idle_frame(self), "timeout")
	newExplosion.set_size(8)
	

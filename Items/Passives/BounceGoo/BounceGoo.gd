extends Node2D

const PLAYER_DATA = preload("res://Entities/Player/Player.tres")
var player: Node2D

onready var rc := $RayCast2D


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	player = PLAYER_DATA.playerObject
	var _discard = player.hurtbox.connect("area_entered", self, "_on_bullet_hit")


func _on_bullet_hit(area: Area2D) -> void:
	if !area.is_in_group("EnemyBullet"): return
	
	var bullet: Node2D = area.get_parent()
	var newBullet: Node2D = bullet.duplicate()
	
	rc.global_position = bullet.global_position
	rc.cast_to = bullet.direction * 360
	rc.force_raycast_update()
	
	var normal = rc.get_collision_normal()
	normal = -bullet.direction if !normal.is_normalized() else normal
	var dir = bullet.direction.bounce(normal)
	
	newBullet.direction = dir
	newBullet.speed = bullet.speed
	newBullet.damage *= 50
	newBullet.global_position = bullet.global_position + (dir * 24)
	GameManager.spawnManager.spawn_object(newBullet)
	yield(TempTimer.idle_frame(self), "timeout")
	newBullet.hitbox.collision_mask = 4

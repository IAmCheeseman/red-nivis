extends Node2D

onready var enemyDetection = $EnemyDetection


const PLAYER = preload("res://Entities/Player/Player.tres")


func _process(_delta: float) -> void:
	global_position = PLAYER.playerObject.global_position
	
	for a in enemyDetection.get_overlapping_areas():
		if a.is_in_group("hurtbox"):
			var enemy = get_area_parent(a)
			enemy.vel = Vector2.ZERO


func get_area_parent(area: Node2D) -> Node2D:
	if !area is KinematicBody2D:
		return get_area_parent(area.get_parent())
	return area

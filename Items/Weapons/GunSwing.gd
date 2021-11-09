extends Node2D

onready var hitbox = $Hitbox

var reflectDir:Vector2

func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.is_in_group("EnemyBullet"):
		body.direction = reflectDir
		body.hitbox.collision_mask = 4
		body.hitbox.damage = hitbox.damage*1.5
		body.speed *= 3
		
		GameManager.emit_signal(
			"screenshake",
			2, 12, .05, .05
		)


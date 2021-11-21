extends Node2D

onready var hitbox = $Hitbox
onready var swishSFX = $SwishSFX

var player: Node2D

func _ready() -> void:
	swishSFX.play()

func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body.is_in_group("PlayerBullet"):
		body.direction = body.global_position.direction_to(
			player.global_position)
		body.hitbox.collision_mask = 1
		body.hitbox.damage = hitbox.damage*1.5
		body.speed *= 1.5
		
		GameManager.emit_signal(
			"screenshake",
			2, 12, .05, .05
		)

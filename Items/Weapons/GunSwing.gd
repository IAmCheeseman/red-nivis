extends Node2D

onready var hitbox = $Hitbox
onready var swishSFX = $SwishSFX

var playerData := preload("res://Entities/Player/Player.tres")
var reflectDir:Vector2

func _ready() -> void:
	swishSFX.play()

func _on_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	
	if body.is_in_group("EnemyBullet"):
		playerData.ammo += int(ceil(float(playerData.maxAmmo) / 3.0))
		
		body.direction = reflectDir
		body.hitbox.collision_mask = 4
		body.hitbox.damage = hitbox.damage * 1.5
		body.speed *= 3
		
		if body.get("vel"): 
			body.vel = -body.vel

		GameManager.emit_signal(
			"screenshake",
			2, 12, .05, .05
		)

func _on_hitbox_hit_object(_area: Area2D) -> void:
	playerData.ammo += int(ceil(float(playerData.maxAmmo) / 3.0))

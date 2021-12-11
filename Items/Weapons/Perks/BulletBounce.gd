extends Node

const TIMES_BOUNCED = "timesBounced"

onready var gun: Node2D

var bounceRaycast = RayCast2D.new()


func _ready() -> void:
	if gun:
		var _discard = gun.connect("bullet_hit", self, "_on_bullet_hit_wall")
	add_child(bounceRaycast)
	bounceRaycast.collide_with_bodies = true
	bounceRaycast.collide_with_areas = false
	bounceRaycast.enabled = true


func _on_bullet_hit_wall(bullet: Node2D) -> void:
	if bullet.has_meta(TIMES_BOUNCED):
		if bullet.get_meta(TIMES_BOUNCED) > 3:
			return
		bullet.set_meta(TIMES_BOUNCED, bullet.get_meta(TIMES_BOUNCED)+1)
	else:
		bullet.set_meta(TIMES_BOUNCED, 1)
	
	var newBullet = bullet.duplicate()
	newBullet.direction = -bullet.direction
	newBullet.speed = bullet.speed*.8
	newBullet.damage = bullet.damage
	newBullet.scale = bullet.scale
	newBullet.lifetime = bullet.lifetimeTimer.time_left
	
	newBullet.connect("hit_wall", gun, "_on_bullet_hit_wall")
	newBullet.connect("hit_enemy", gun, "_on_bullet_hit_enemy")
	
	bounceRaycast.global_position = bullet.global_position
	bounceRaycast.cast_to = bullet.direction*32
	bounceRaycast.force_raycast_update()
	
	var normal = bounceRaycast.get_collision_normal()
	if normal != Vector2.ZERO:
		newBullet.direction = bullet.direction.bounce(normal)
	else:
		newBullet.direction = -bullet.direction
	
	newBullet.global_position = bullet.global_position+newBullet.direction*16
	
	GameManager.spawnManager.spawn_object(newBullet)

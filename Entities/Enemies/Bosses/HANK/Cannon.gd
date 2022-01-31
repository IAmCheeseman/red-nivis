extends Node2D

onready var charge = $ChargeTimer
onready var sprite = $Sprite
onready var chargeSprite = $Charge
onready var hank = owner

export var flashTime := .8

const BULLET = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")



func _process(_delta: float) -> void:
	sprite.material.set_shader_param("isOn", 0)
	if charge.is_stopped():
		sprite.scale = Vector2(-1, 1)
		chargeSprite.scale = Vector2.ZERO
		return
	if charge.time_left < flashTime:
		sprite.material.set_shader_param("isOn", 1)
	
	sprite.scale.x = clamp(charge.time_left / charge.wait_time, .6, INF)
	sprite.scale.y = 1 + (1 - sprite.scale.x)
	sprite.scale.x *= -1
	
	chargeSprite.scale.x = 1 - (charge.time_left / charge.wait_time)
	chargeSprite.scale.y = chargeSprite.scale.x


func attack() -> bool:
	if !charge.is_stopped() or rand_range(0, 1) < .90: return false
	charge.start()
	return true


func shoot() -> void:
	var dir = global_position.direction_to(GameManager.player.global_position)
	var _discard = create_bullet(
		dir,
		global_position + (dir * 24)
	)


func _on_bullet_bounce(bullet: Node2D) -> void:
	var rc = RayCast2D.new()
	rc.enabled = true
	rc.global_position = bullet.global_position
	GameManager.spawnManager.add_child(rc)
	rc.cast_to = bullet.direction * 32
	rc.force_raycast_update()

	var normal = rc.get_collision_normal()
	var dir
	
	if normal.is_normalized() and rc.is_colliding(): dir = bullet.direction.bounce(normal)
	else: dir = -bullet.direction
	
	var createdBullet = create_bullet(dir, bullet.global_position + (dir * 16))
	
	if !bullet.has_meta("timesBounced"): createdBullet.set_meta("timesBounced",    1)
	else: createdBullet.set_meta("timesBounced", bullet.get_meta("timesBounced") + 1)

	if createdBullet.get_meta("timesBounced") > 5:
		createdBullet.queue_free()
	
	rc.queue_free()


func create_bullet(dir, pos) -> Node2D:
	var newBullet = BULLET.instance()
	
	newBullet.direction = dir
	newBullet.global_position = pos
	newBullet.speed = 130
	newBullet.scale *= 2
	newBullet.damage = 2
	newBullet.connect("hitCollision", self, "_on_bullet_bounce")
	
	GameManager.spawnManager.spawn_object(newBullet)
	
	hank.bullets.append(newBullet)
	
	return newBullet

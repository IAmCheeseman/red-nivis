extends Node2D

onready var anim = $"../../AnimationPlayer"
onready var sprite = $"../../Sprite"
onready var parent = $"../../"
onready var hitbox = $SpinHitbox/CollisionShape2D
onready var stopTimer = $StopTimer

var shooting = false

func test() -> bool:
	if parent.headless:
		shooting = true
		stopTimer.start()
		return true
	shooting = false
	return false


func attack(delta: float) -> void:
	parent.get_target_pos()
	var vectorTarget = Vector2(parent.targetX, parent.global_position.y)
	var dir: float = parent.global_position.direction_to(vectorTarget).x
	
	parent.vel.x = lerp(parent.vel.x, dir * (parent.speed / 5), parent.accel * delta)
	
	anim.play("Spin")
	hitbox.disabled = false


func shoot() -> void:
	if !shooting: return
	var bulletCount = rand_range(1, 2)
	for i in bulletCount:
		var newBullet = preload("res://Entities/Enemies/EnemyBullet/GnomeBullet/GnomeBullet.tscn").instance()
		var direction = [Vector2.RIGHT, Vector2.LEFT][round(rand_range(0, 1))]\
			.rotated(deg2rad(rand_range(-25, 25)))
		newBullet.direction = direction
		newBullet.global_position = global_position - Vector2(0, 16)
		newBullet.speed = 50
		GameManager.spawnManager.spawn_object(newBullet)


func stop() -> void:
	if parent.state == parent.DEAD: return
	parent.state = parent.WALK
	hitbox.disabled = true
	shooting = false


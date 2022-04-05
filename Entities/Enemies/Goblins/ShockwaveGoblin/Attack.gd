extends Node2D

const BULLET = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")

onready var sprite = $Sprite
onready var shootTimer = $ShootTimer
onready var bounceRay = $BounceRay

export var recoil := 140.0 / 5

var player: Node2D

func _process(delta: float) -> void:
	if !player:
		player = owner.player
		return

	sprite.look_at(player.global_position)
	sprite.flip_v = player.global_position.x < global_position.x


func shoot() -> void:
	shootTimer.start(rand_range(3, 5))
	if !player: return

	var pointDir = Vector2.RIGHT.rotated(sprite.rotation)

	owner.vel = -pointDir * recoil

	for i in 8:
		create_bullet(
			null,
			70 + rand_range(-30, 0),
			pointDir.rotated(deg2rad(rand_range(-35, 35)))
		)


func create_bullet(bullet=null, speed:int=0, dir:Vector2=Vector2.ZERO, timesLeft:int=3) -> void:
	if timesLeft <= 0: return
	var realDir = dir
	var pos = global_position
	if dir == Vector2.ZERO:
		bounceRay.global_position = bullet.global_position
		bounceRay.cast_to = bullet.direction * 32
		bounceRay.force_raycast_update()

		realDir = bullet.direction.bounce(bounceRay.get_collision_normal())
		pos = bullet.global_position + (realDir * 8)

	var newBullet = BULLET.instance()
	newBullet.global_position = pos
	newBullet.direction = realDir
	newBullet.speed = speed

	newBullet.connect(
		"hitCollision", self, "create_bullet",
		[speed, Vector2.ZERO, timesLeft-1]
	)

	GameManager.spawnManager.spawn_object(newBullet)

	yield(TempTimer.idle_frame(self), "timeout")

	if !is_instance_valid(newBullet): return

	newBullet.hitbox.kbStrengh = 6

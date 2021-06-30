extends Node2D

onready var gun = get_parent()
onready var pivot = gun.get_node("Pivot")
onready var barrelEnd = gun.get_node("Pivot/BarrelEnd")
onready var cooldownTimer = gun.get_node("Cooldown")
onready var gunSprite = gun.get_node("Pivot/GunSprite")
onready var hitCast = gun.get_node("Pivot/ShotLine")

var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")
var shootSound : SoundManager
var rotVel = 0
var lastFrameRot = 0

onready var rotOffset = -gunSprite.rotation
var isFlipped = false


export var maxHitDist = 32


func _ready():
	hitCast.cast_to.x = maxHitDist


func _physics_process(delta):
	# Flipping the gun based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0:
		gunSprite.scale.y = -1 if !isFlipped else 1
	else:
		gunSprite.scale.y = 1 if !isFlipped else -1
	# Showing the gun behind the parent based on rotation
	gun.get_parent().show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = gunSprite.global_rotation
	pivot.look_at(get_global_mouse_position())
	var targetRot = pivot.global_rotation

	gunSprite.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the gun down after it's been kicked up
	gunSprite.rotation = lerp_angle(gunSprite.rotation, rotOffset, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 12*delta)

	# Shooting
	if Input.is_action_pressed("use_item") and gun.canShoot:
		shoot()


func shoot():
	var hit
	hitCast.cast_to = Vector2.RIGHT.rotated(deg2rad(-10))
	for i in 3:
		hitCast.cast_to = Vector2.RIGHT.rotated(hitCast.cast_to.angle()+deg2rad(10))*maxHitDist
		hitCast.force_raycast_update()
		if hit:
			break
		hit = hitCast.get_collider()

	if hit:
		if hit.is_in_group("hurtbox") and !hit.is_in_group("enemy"):
			hit.take_damage(gun.damage, global_position.direction_to(hit.global_position))

	gunSprite.scale.y = 1 if gunSprite.scale.y == -1 else -1
	isFlipped = !isFlipped
	rotOffset = -rotOffset
	pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))
	gun.canShoot = false
	cooldownTimer.start(gun.cooldown)

	# Screenshake

	# Getting the parameters
	var strength = 8*GameManager.percentage_from(10, gun.damage)
	strength *= gun.cooldown+.5
	var freq = gun.damage/1000
	freq *= gun.cooldown+.5
	freq = clamp(freq, .08, .2)

	var direction = global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake", 0, strength*2, freq, freq, strength/3, direction)

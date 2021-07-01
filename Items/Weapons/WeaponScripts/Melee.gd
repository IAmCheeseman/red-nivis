extends Node2D

onready var weapon = get_parent()
onready var pivot = weapon.get_node("Pivot")
onready var barrelEnd = weapon.get_node("Pivot/BarrelEnd")
onready var cooldownTimer = weapon.get_node("Cooldown")
onready var weaponSprite = weapon.get_node("Pivot/GunSprite")
onready var hitCast = weapon.get_node("Pivot/ShotLine")

var hitbox = preload("res://Colliders/MeleeHitbox.tscn")
var shootSound : SoundManager
var rotVel = 0
var lastFrameRot = 0

onready var rotOffset = -weaponSprite.rotation
var isFlipped = false

export var hitboxHeight = 32
export var hitboxWidth = 25


func _ready():
	hitCast.cast_to.x = hitboxHeight


func _physics_process(delta):
	# Flipping the weapon based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0:
		weaponSprite.scale.y = -1 if !isFlipped else 1
	else:
		weaponSprite.scale.y = 1 if !isFlipped else -1
	# Showing the weapon behind the parent based on rotation
	weapon.get_parent().show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = weaponSprite.global_rotation
	pivot.look_at(get_global_mouse_position())
	var targetRot = pivot.global_rotation

	weaponSprite.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the weapon down after it's been kicked up
	weaponSprite.rotation = lerp_angle(weaponSprite.rotation, rotOffset, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 12*delta)

	# Shooting
	if Input.is_action_pressed("use_item") and weapon.canShoot:
		shoot()


func shoot():
	#var hit
	#hitCast.cast_to = Vector2.RIGHT.rotated(deg2rad(-10))
	#for i in 3:
	#	hitCast.cast_to = Vector2.RIGHT.rotated(hitCast.cast_to.angle()+deg2rad(10))*hitboxHeight
	#	hitCast.force_raycast_update()
	#	if hit:
	#		break
	#	hit = hitCast.get_collider()
	#if hit:
	#	if hit.is_in_group("hurtbox") and !hit.is_in_group("enemy"):
	#		hit.take_damage(weapon.damage, global_position.direction_to(hit.global_position))

	var newHitbox = hitbox.instance()
	add_child(newHitbox)
	newHitbox.setup(weapon.damage, hitboxHeight, hitboxWidth, get_local_mouse_position().angle())

	weaponSprite.scale.y = 1 if weaponSprite.scale.y == -1 else -1
	isFlipped = !isFlipped
	rotOffset = -rotOffset
	pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))
	weapon.canShoot = false
	cooldownTimer.start(weapon.cooldown)

	# Screenshake

	# Getting the parameters
	var strength = 8*GameManager.percentage_from(10, weapon.damage)
	strength *= weapon.cooldown+.5
	var freq = weapon.damage/1000
	freq *= weapon.cooldown+.5
	freq = clamp(freq, .08, .2)

	var direction = global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake", 0, strength*2, freq, freq, strength/3, direction)

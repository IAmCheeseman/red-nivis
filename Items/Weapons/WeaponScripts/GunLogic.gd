extends Node2D

onready var pivot = get_parent().get_node("Pivot")
onready var barrelEnd = get_parent().get_node("Pivot/BarrelEnd")
onready var cooldownTimer = get_parent().get_node("Cooldown")
onready var gunSprite = get_parent().get_node("Pivot/GunSprite")
onready var gun = get_parent()

export var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")
var shootSound : SoundManager
var rotVel = 0
var holdShots = 0


func _physics_process(delta):
	# Flipping the gun based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0:
		gunSprite.scale.y = -1
	else:
		gunSprite.scale.y = 1
	# Showing the gun behind the parent based on rotation
	gun.get_parent().show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = gunSprite.global_rotation
	pivot.look_at(get_global_mouse_position())
	var targetRot = pivot.global_rotation

	gunSprite.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the gun down after it's been kicked up
	gunSprite.rotation = lerp_angle(gunSprite.rotation, 0, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 12*delta)

	# Shooting
	var hasEnoughAmmo = gun.player.ammo-gun.cost > 0

	if Input.is_action_pressed("use_item")\
	and gun.canShoot\
	and hasEnoughAmmo\
	and holdShots < gun.maxHoldShots:
		gun.player.ammo -= gun.cost
		Cursor.get_node("Sprite").scale = Vector2(1.2, 1.2)
		shoot()
	elif Input.is_action_just_pressed("use_item")\
	and !hasEnoughAmmo:
		gun.noAmmoClick.play()

func shoot():
	pass

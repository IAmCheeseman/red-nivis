extends Node2D

onready var pivot := get_parent().get_node("Pivot")
onready var barrelEnd := get_parent().get_node("Pivot/BarrelEnd")
onready var cooldownTimer := get_parent().get_node("Cooldown")
onready var gunSprite := get_parent().get_node("Pivot/GunSprite")
onready var gun := get_parent()

export var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")
var shell := preload("res://Items/Weapons/Bullet/Shells/Shell.tscn")
var playerData := preload("res://Entities/Player/Player.tres")
var shootSound : SoundManager
var rotVel := .0
var holdShots := 0
var isReloading := false

var swinging := false
var swingStartDeg := .0
var targetPos:Vector2

func _ready() -> void:
	targetPos = position


func _physics_process(delta) -> void:
	# Flipping the gun based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0: gun.visuals.scale.y = -1
	else: gun.visuals.scale.y = 1
	# Showing the gun behind the parent based on rotation
	gun.get_parent().show_behind_parent = local.y < 0

	# Settling the rotation of the gun down after it's been kicked up
	if !swinging:
		pivot.look_at(get_global_mouse_position())
	else:
		pivot.rotation += 15*delta
		if pivot.rotation_degrees-swingStartDeg > 65*2:
			swinging = false
	
	gun.visuals.rotation = lerp_angle(gun.visuals.rotation, 0, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 6*delta)

	# Shooting
	var hasEnoughAmmo := playerData.ammo > 0

	if Input.is_action_pressed("use_item")\
	and gun.canShoot\
	and hasEnoughAmmo\
	and holdShots != gun.stats.maxHoldShots\
	and !GameManager.editingInventory\
	and !GameManager.inGUI\
	and !playerData.playerObject.lockMovement:
		playerData.ammo -= 1
		Cursor.get_node("Sprite").scale = Vector2(1.2, 1.2)
		shoot()
		
		var newShell = shell.instance()
		var dir = -global_position.direction_to(get_global_mouse_position())-Vector2(0, 2)
		newShell.direction = -global_position.direction_to(get_global_mouse_position())-Vector2(0, 2)
		newShell.position = global_position+(dir*2)
		GameManager.spawnManager.spawn_shell(newShell)
		newShell.sprite.texture = gun.stats.shellSprite
		
	elif Input.is_action_just_pressed("use_item")\
	and !hasEnoughAmmo:
		gun.noAmmoClick.play()


func shoot() -> void:
	pass


func _input(event: InputEvent) -> void:
	# Meleeing
	if event.is_action_pressed("melee") and !swinging:
#		gun.position.x += 10
		swinging = true
		pivot.rotation_degrees -= 65
		swingStartDeg = pivot.rotation_degrees
		pivot.scale = Vector2.ONE*1.5

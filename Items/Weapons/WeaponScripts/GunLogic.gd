extends Node2D

onready var pivot := get_parent().get_node("Pivot")
onready var barrelEnd := get_parent().get_node("Pivot/BarrelEnd")
onready var cooldownTimer := get_parent().get_node("Cooldown")
onready var gunSprite := get_parent().get_node("Pivot/GunSprite")
onready var gun := get_parent()

export var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")
var shell := preload("res://Items/Weapons/Bullet/Shells/Shell.tscn")
var playerData := preload("res://Entities/Player/Player.tres")
var swing := preload("res://Items/Weapons/GunSwing.tscn")
var shootSound : SoundManager
var rotVel := .0
var holdShots := 0
var isReloading := false

var swinging := false
var swingStartDeg := .0
var swingDir := 1
var targetPos:Vector2


# warning-ignore:unused_signal
signal gun_shot(bullet)
# warning-ignore:unused_signal
signal gun_aimed()
signal bullet_hit_wall(bullet)
signal bullet_hit_enemy(bullet)
signal bullet_hit(bullet)

signal melee()


func _ready() -> void:
	if gun.burst:
		cooldownTimer.set_meta("fromReload", true)
		var _discard = cooldownTimer.connect("timeout", self, "_on_cooldown_timeout")
	targetPos = position

func _on_cooldown_timeout() -> void:
	if gun.canShoot\
	and playerData.ammo > 0\
	and !GameManager.editingInventory\
	and !GameManager.inGUI\
	and !playerData.playerObject.lockMovement\
	and !swinging\
	and !cooldownTimer.get_meta("fromReload"):
		pre_shoot()
	cooldownTimer.set_meta("fromReload", false)


func _physics_process(delta) -> void:
	# Flipping the gun based on rotation
	if GameManager.inGUI: return
	var local = barrelEnd.global_position-global_position
	if local.x < 0: gun.visuals.scale.y = -1
	else: gun.visuals.scale.y = 1
	# Showing the gun behind the parent based on rotation
	#gun.get_parent().show_behind_parent = local.y < 0

	# Settling the rotation of the gun down after it's been kicked up
	if !swinging:
		if !playerData.playerObject.lockMovement:
			var before = pivot.rotation
			pivot.look_at(Utils.get_global_mouse_position())
			pivot.rotation = lerp(before, pivot.rotation, 20*delta)
	else:
		pivot.rotation += 12*delta*swingDir
		if abs(pivot.rotation_degrees-swingStartDeg) > 65*2:
			swinging = false
	gun.visuals.rotation = lerp_angle(gun.visuals.rotation, 0, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 6*delta)

	gun.visuals.position = gun.visuals.position.move_toward(gun.gunPos, 30 * delta)

	# Shooting
	var hasEnoughAmmo := playerData.ammo > 0

	playerData.isReloading = gun.isReloading

	if Input.is_action_pressed("use_item")\
	and gun.canShoot\
	and hasEnoughAmmo\
	and holdShots != gun.maxHoldShots\
	and !GameManager.editingInventory\
	and !GameManager.inGUI\
	and !playerData.playerObject.lockMovement\
	and !swinging:
		pre_shoot()

	elif Input.is_action_just_pressed("use_item")\
	and !hasEnoughAmmo:
		gun.noAmmoClick.play()


func pre_shoot() -> void:
	playerData.ammo -= 1
	gun.inventory.items[gun.invenIdx].ammoLeft = playerData.ammo
	Cursor.get_node("Sprite").scale = Vector2(
		rand_range(1, 1.2), rand_range(1, 1.2))
	shoot()

	var newShell = shell.instance()
	var dir = -global_position.direction_to(Utils.get_global_mouse_position())-Vector2(0, 2)
	newShell.direction = -global_position.direction_to(Utils.get_global_mouse_position())-Vector2(0, 2)
	newShell.position = global_position+(dir*2)
	GameManager.spawnManager.spawn_object(newShell)
	yield(TempTimer.idle_frame(self), "timeout")
	newShell.sprite.texture = gun.shellSprite


func shoot() -> void:
	pass


func _input(event: InputEvent) -> void:
	# Meleeing
	if event.is_action_pressed("melee")\
	and !swinging\
	and gun.meleeCooldown.is_stopped()\
	and !GameManager.inGUI\
	and playerData.stamina > 0:
		melee()
	if event.is_action_pressed("reload"):
		cooldownTimer.start(gun.reloadSpeed)
		gun.isReloading = true


func melee() -> void:
	playerData.stamina -= 1
	
	var recoil = get_local_mouse_position().normalized()*gun.recoil
	recoil.y /= 5
	playerData.playerObject.vel += recoil

	swinging = true
	swingDir = -swingDir
	pivot.rotation_degrees -= 65*swingDir
	swingStartDeg = pivot.rotation_degrees
	pivot.scale = Vector2.ONE*1.5


	var angle = Utils.get_local_mouse_position(self).angle()

	var newSwing = swing.instance()
	newSwing.rotation = angle
	newSwing.reflectDir = Utils.get_local_mouse_position(self).normalized()
	owner.add_child(newSwing)

	var hb = newSwing.get_node("Hitbox")
	hb.damage = gun.damage*1.25 if gun.meleeDamageOverride == -1 else gun.meleeDamageOverride

	newSwing.global_position = global_position+Vector2.RIGHT.rotated(angle)*8

	GameManager.emit_signal(
		"screenshake",
		1, 3, .05, .05,
		Utils.get_local_mouse_position(self).normalized()
	)

	gun.meleeCooldown.start()
	gun.canSwing = false
	
	emit_signal("melee")


# warning-ignore:shadowed_variable
func _on_bullet_hit_wall(bullet: Node2D) -> void:
	emit_signal("bullet_hit", bullet)
	emit_signal("bullet_hit_wall", bullet)
# warning-ignore:shadowed_variable
func _on_bullet_hit_enemy(bullet: Node2D) -> void:
	emit_signal("bullet_hit", bullet)
	emit_signal("bullet_hit_enemy", bullet)

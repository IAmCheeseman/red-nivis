extends KinematicBody2D

enum {IDLE, MOVE, FIRE_CHARGE, FIRE_FAST, FIRE_SHOTGUN}
var fireStates = [FIRE_FAST, FIRE_SHOTGUN, FIRE_CHARGE]

# Visuals
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var hpBar = $BossBar/VBoxContainer/ProgressBar

# Collisions
onready var playerDetection = $Collisions/PlayerDetection
onready var collisionChecker = $Collisions/CollisionChecker

# Timers
onready var fireChargeTimer = $Timers/FireChargeTimer
onready var fireCooldown = $Timers/FireCooldown
onready var fireStateTimer = $Timers/FireStateTimer
onready var walkDirChangeTimer = $Timers/WalkDirChange

# Gun
onready var gun = $Gun
onready var gunAnim = $Gun/AnimationPlayer
onready var barrelEnd = $Gun/BarrelEnd

# Exports
export var maxHealth := 550

export var maxSpeed := 320
export var backwardsMod := .5
export var accel := 5.0

export var fastFireCooldown := .2
export var fastFireShots := 8
export var fastFireBulletSpeed := 110

export var shotgunBulletSpeed := 90
export var shotgunCooldown := .8
export var shotgunShots := 2
export var shotgunBullets = 4
export var shotgunSpread := 16

export var chargeDamage := 2

# Other variables
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn") 
var shockwave = preload("res://Entities/Enemies/Shockwave/Shockwave.tscn")

var state := IDLE

onready var health = maxHealth

var speed := 0
var vel := Vector2.ZERO
var target := 0.0

var fireCount = 0

var player: Node2D


func _process(delta: float) -> void:
	if !is_on_floor(): vel.y += Globals.GRAVITY*delta
	
	# Grabbing the player
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
	else:
		if fireStateTimer.is_stopped():
			if !state in fireStates:
				fireStates.shuffle()
				state = fireStates.front()
		# States
		match state:
			IDLE:
				vel.x = lerp(vel.x, 0, accel*delta)
				anim.play("Idle")
				if walkDirChangeTimer.is_stopped():
					select_target_x()
					state = MOVE
			MOVE:
				move_state(delta)
			FIRE_CHARGE:
				fire_state(delta)
				gunAnim.play("ChargeUp")
			FIRE_FAST:
				fire_state(delta)
				# Firing
				if fireCooldown.is_stopped():
					GameManager.emit_signal("screenshake", 1, 4, .05, .05)
					var newBullet = bullet.instance()
					newBullet.global_position = barrelEnd.global_position
					newBullet.direction = barrelEnd.global_position.direction_to(player.global_position)
					newBullet.speed = fastFireBulletSpeed
					
					GameManager.spawnManager.spawn_object(newBullet)
					
					fireCooldown.start(fastFireCooldown)
					
					fireCount += 1
					if fireCount >= fastFireShots:
						fireStateTimer.start()
						fireCount = 0
						state = IDLE
			FIRE_SHOTGUN:
				fire_state(delta)
				# Firing
				if fireCooldown.is_stopped():
					GameManager.emit_signal("screenshake", 1, 8, .05, .05)
					for i in shotgunBullets:
						var newBullet = bullet.instance()
						
						var dir = barrelEnd.global_position.direction_to(player.global_position)
						var spread = deg2rad(shotgunSpread*i-(shotgunSpread*(shotgunBullets-1)*.5))
						
						
						newBullet.global_position = barrelEnd.global_position
						newBullet.direction = dir.rotated(spread)
						newBullet.speed = shotgunBulletSpeed
						
						GameManager.spawnManager.spawn_object(newBullet)
						
					fireCooldown.start(shotgunCooldown)
					
					fireCount += 1
					if fireCount >= shotgunShots:
						fireStateTimer.start()
						fireCount = 0
						state = IDLE
						
	var _discard = move_and_slide(vel*delta)


func fire_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, accel*delta)
	gun.look_at(player.global_position)
	gun.rotation_degrees = stepify(gun.rotation_degrees, 6)
	anim.play("Shoot")
	
	sprite.scale.x = -1
	gun.scale.y = 1
	if player.global_position.x < global_position.x:
		sprite.scale.x = 1
		gun.scale.y = -1


func move_state(delta: float) -> void:
	if is_close_to_target():# or walkDirChangeTimer.is_stopped():
		walkDirChangeTimer.stop()
		state = IDLE
		walkDirChangeTimer.start(rand_range(2, 4))
	
	# Animation
	sprite.scale.x = -1
	if player.global_position.x < global_position.x:
		sprite.scale.x = 1
	
	if !int(global_position.x) in range(target, player.global_position.x):
		anim.play("WalkForwards")
		speed = maxSpeed
	else:
		anim.play("WalkBackwards")
		speed = int(maxSpeed*.75)
	
	var targetv = -1 if global_position.x > target else 1
	vel.x = lerp(vel.x, targetv*speed, accel*delta)


func charge_shot() -> void:
	GameManager.emit_signal("screenshake", 1, 9, .05, .05)
	
	var newBullet = bullet.instance()
	newBullet.global_position = barrelEnd.global_position
	newBullet.direction = barrelEnd.global_position.direction_to(player.global_position)
	newBullet.speed = fastFireBulletSpeed
	newBullet.scale = Vector2.ONE*2
	newBullet.damage = chargeDamage
	newBullet.connect("hitCollision", self, "_on_charge_bullet_hit", [newBullet])
	newBullet.set_meta("bounceTimes", 0)
	
	GameManager.spawnManager.spawn_object(newBullet)
	
	fireCooldown.start(fastFireCooldown)
	
	fireStateTimer.start()
	gunAnim.play("Reset")
	fireCount = 0
	state = IDLE


func _on_charge_bullet_hit(bulletPosition: Vector2, oldBullet:Node2D) -> void:
	var raycast = RayCast2D.new()
	raycast.global_position = bulletPosition
	raycast.enabled = true
	raycast.cast_to = Vector2(0, 8)
	add_child(raycast)
	raycast.force_raycast_update()
	
	GameManager.emit_signal("screenshake", 1, 11, .05, .15)
	
	if !raycast.is_colliding() or oldBullet.get_meta("bounceTimes") < 3:
		var newBullet = bullet.instance()
		newBullet.global_position = bulletPosition
		newBullet.direction = bulletPosition.direction_to(player.global_position)
		newBullet.position += newBullet.direction.normalized()*16
		newBullet.speed = fastFireBulletSpeed
		newBullet.scale = Vector2.ONE*2
		newBullet.damage = chargeDamage
		newBullet.connect("hitCollision", self, "_on_charge_bullet_hit", [newBullet])
		newBullet.set_meta("bounceTimes", oldBullet.get_meta("bounceTimes")+1)
		
		GameManager.spawnManager.spawn_object(newBullet)
		return
	
	var spawnPoint = to_local(raycast.get_collision_point())
	var direction = 1
	for i in 2:
		var newShockwave = shockwave.instance()
		newShockwave.position = spawnPoint
		newShockwave.position += Vector2(12, 0)*direction
		
		newShockwave.scale.x = direction
		
		GameManager.spawnManager.spawn_object(newShockwave)
		direction = -direction
	
	raycast.queue_free()


func is_close_to_target() -> bool:
	return global_position.distance_to(Vector2(target, global_position.y)) < 8


func select_target_x() -> void:
	if !player: return
	var i = 0
	while true:
		target = player.global_position.x+rand_range(-128, 128)
		
		collisionChecker.cast_to.x = target-global_position.x
		collisionChecker.force_raycast_update()
		var isColliding = collisionChecker.is_colliding()
		
		if i > 100 and !isColliding:
			break
		i += 1


func _on_hurt(amount, _dir) -> void:
	health -= amount
	hpBar.value = Utils.percentage_of(health, maxHealth)
	GameManager.frameFreezer.freeze_frames(.1)
	if health <= 0:
		# Dropping the hp
		var playerData = player.get_parent().playerData
		for i in playerData.maxHealth-playerData.health:
			var newHealth = healthPickup.instance()
			newHealth.position = position-Vector2(0, sprite.texture.get_height()*.25)
			var force = (Vector2.UP+Vector2(rand_range(-.25, .25), 0)).normalized()*70
			newHealth.apply_central_impulse(force)
			GameManager.spawnManager.spawn_object(newHealth)
			
			GameManager.frameFreezer.freeze_frames(.5)
			
		# Getting done
		queue_free()



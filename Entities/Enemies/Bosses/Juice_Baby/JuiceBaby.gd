extends KinematicBody2D

enum { MOVE, TELEPORT, SHOOT }

onready var playerDetection = $Collisions/PlayerDetection
onready var wallRay = $Collisions/WallRay

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var gunPositions = $Sprite/GunShootPositions
onready var gun = $Sprite/Gun
onready var gunSprite = $Sprite/Gun/Sprite

onready var shootTimer = $Timer/ShootTimer

var player: Area2D

export var accel := 1.0
export var frict := 200.0
export var maxSpeed := 50

var vel: Vector2

var state = MOVE

var shots = 0
var gunTarget: Vector2
var prevGunPos: Vector2


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	
	if !player:
		player = playerDetection.get_player()
	else:
		gun.look_at(player.global_position)
		
		sprite.scale.x = 1
		if player.global_position.x > global_position.x:
			sprite.scale.x = -1
		gunSprite.scale.y = -1
		
		match state:
			MOVE:
				var diff = (global_position.x - player.global_position.x)
				var dir = -1 if diff < 0 else 1
# warning-ignore:narrowing_conversion
				dir = (1 if Utils.is_even(OS.get_ticks_msec() / rand_range(1000, 5000)) else -1)\
					if diff > 220 / 3 else dir
				
				vel.x = lerp(vel.x, dir * maxSpeed, accel * delta)
				
				anim.play("Walk")
				
				if global_position.distance_to(player.global_position) < 48:
					state = TELEPORT
			SHOOT:
				vel.x = lerp(vel.x, 0, frict * delta)
				
				var percentageOver = shootTimer.time_left / shootTimer.wait_time
				var diff = (prevGunPos - gunTarget) * percentageOver
				
				gun.position = gunTarget + diff
			TELEPORT:
				anim.play("Teleport")
	
	vel.y = move_and_slide(vel).y


func teleport() -> void:
	vel.x = 0
	
	var diff = (global_position.x - player.global_position.x)
	var dir = -1 if diff > 0 else 1
	
	wallRay.cast_to = Vector2(dir, 0) * 200
	wallRay.force_raycast_update()
	
	var sub = 0
	if wallRay.is_colliding():
		sub = wallRay.get_collision_point().x
	
	global_position = Vector2(global_position.x + (dir * rand_range(100, (200 - sub))), global_position.y)


func shoot() -> void:
	if state != SHOOT: return
	
	yield(TempTimer.timer(self, .1), "timeout")
	
	var bullets = 3
	var spread = 12
	for i in bullets:
		var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn").instance()
		var pos = gun.global_position - Vector2(0, 8)
		var dir = pos.direction_to(player.global_position - Vector2(0, 8))
		var angle = -((bullets * spread) / 2) + (spread * i)
		dir = dir.rotated(deg2rad(angle))
		
		bullet.global_position = pos + (dir * 8)
		bullet.direction = dir
		bullet.damage = 1
		bullet.speed = 175
		GameManager.spawnManager.spawn_object(bullet)
	
	
	prevGunPos = gunTarget
	var oldGunTarget = gunTarget
	while gunTarget == oldGunTarget:
		gunTarget = gunPositions.get_child(randi() % gunPositions.get_child_count()).position
	
	shots += 1
	if shots >= 3:
		shots = 0
		gun.position = gunPositions.get_child(0).position
		state = MOVE
	
	shootTimer.start()


func finish_teleport() -> void:
	state = MOVE


func attack() -> void:
	if state == TELEPORT: return
	
	var attackStates = [SHOOT]
	state = attackStates[randi() % attackStates.size()]
	
	match state:
		SHOOT:
			shootTimer.start()
			prevGunPos = gun.position

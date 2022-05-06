extends KinematicBody2D

onready var barrel = $Barrel
onready var shootSFX = $ShootSound

var canShoot = false
var shots = 0

export var damage := 50
export var speed := 350.0
export var accel := 1000.0
var bullet := preload("res://Items/Weapons/Bullet/Bullet.tscn")
var shell := preload("res://Items/Weapons/Bullet/Shells/Shell.tscn")

var player := preload("res://Entities/Player/Player.tres")

var enemies = []

var vel: Vector2
var targetPos: Vector2


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	global_position = player.playerObject.global_position - Vector2(0, 8)
	get_target_pos()


func _process(delta: float) -> void:
	var smallestDist = 100000
	for i in enemies:
		if !is_instance_valid(i):
			enemies.erase(i)
			continue
		
		var dist = global_position.distance_to(i.global_position)
		if dist < smallestDist:
			smallestDist = dist
			barrel.look_at(i.global_position)
	
	if enemies.size() == 0:
		canShoot = false
		barrel.look_at(global_position + vel)
	
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		accel * delta
	)
	vel = move_and_slide(vel)


func start_attack() -> void:
	canShoot = enemies.size() != 0


func shoot() -> void:
	if !canShoot: return
	
	var newShell = shell.instance()
	var shellDir = -global_position.direction_to(Utils.get_global_mouse_position())-Vector2(0, 2)
	newShell.direction = -global_position.direction_to(Utils.get_global_mouse_position())-Vector2(0, 2)
	newShell.position = global_position+(shellDir*2)
	GameManager.spawnManager.spawn_object(newShell)
	yield(TempTimer.idle_frame(self), "timeout")
	newShell.sprite.texture = preload("res://Items/Weapons/Bullet/Shells/shellPistol.png")
	
	var dir = Vector2.RIGHT.rotated(barrel.rotation)
	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = 450
	newBullet.lifetime = 1
	newBullet.global_position = global_position + (dir * 15)
	newBullet.damage = damage
	GameManager.spawnManager.spawn_object(newBullet)
	
	shootSFX.play()
	
	shots += 1
	if shots == 3:
		shots = 0
		canShoot = false


func _on_found_enemy(area: Area2D) -> void:
	if !area.is_in_group("EnemyBullet"):
		enemies.append(area)


func get_target_pos() -> void:
	var playero = player.playerObject
	targetPos = playero.global_position + Vector2(
		rand_range(-64, 64),
		rand_range(-64, -32)
	)

extends KinematicBody2D

enum Type {
	Stationary,
	Rotary,
	Vertical,
	Horizontal
}

const BULLET = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")

onready var turretBarrel = $TurretBarrel
onready var playerDetection = $Collisions/PlayerDetection
onready var shootSFX = $ShootSFX
onready var cooldown = $CooldownTimer

var player: Area2D

export(int, "Stationary", "Rotary", "Vertical", "Horizontal") var type := 0
export var damage := 35

var rotProg := 0.0
var startingPoint := Vector2.ZERO
var dir := 1
var speed = 16 * 3

func _ready() -> void:
	startingPoint = position

func _process(delta: float) -> void:
	if !player:
		player = playerDetection.get_player()
		
		if player: 
			cooldown.start()
	else:
		turretBarrel.look_at(player.global_position)
	match type:
		Type.Stationary:
			pass
		Type.Rotary:
			rotProg += delta * 0.25
			position = (Vector2.RIGHT.rotated(TAU * rotProg) * 32) + startingPoint
		Type.Vertical:
			var vel = Vector2(0, dir)
			if test_move(transform, vel): dir *= -1
			move_and_slide(vel * speed)
		Type.Horizontal:
			var vel = Vector2(dir, 0)
			if test_move(transform, vel): dir *= -1
			move_and_slide(vel * speed)


func shoot() -> void:
	var newBullet = BULLET.instance()
	newBullet.direction = global_position.direction_to(GameManager.player.global_position)
	newBullet.global_position = global_position + (newBullet.direction * 24)
	newBullet.speed = 100
	newBullet.damage = damage
	
	GameManager.spawnManager.spawn_object(newBullet)
	
	shootSFX.play()

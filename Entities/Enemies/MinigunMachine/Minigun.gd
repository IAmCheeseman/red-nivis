extends Node2D


export var startCooldown:float = 2.3
export var minCooldown:float = .5
export var overheatShotCount:int = 7
export var damage = 5

onready var cooldown = $Cooldown
onready var overheatCooldown = $OverheatCooldown
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var shootSFX = $ShootSFX

var currentCooldown = 2.3
var shotsInARow = 0
var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")
var isOn = false
var started = false


func _ready() -> void:
	currentCooldown = startCooldown


func start() -> void:
	if !started:
		anim.play("WindUp")
		started = true


func start_shooting() -> void:
	isOn = true
	cooldown.stop()
	overheatCooldown.stop()


func _process(delta: float) -> void:
	scale = Vector2.ONE
	if anim.current_animation != "WindUp":
		sprite.scale = sprite.scale.move_toward(
			Vector2.ONE, 5*delta)

	if !overheatCooldown.is_stopped()\
	or !cooldown.is_stopped()\
	or !isOn\
	or anim.is_playing():
		return
	currentCooldown = clamp(currentCooldown*.5, minCooldown, startCooldown)
	cooldown.stop()
	cooldown.start(currentCooldown)
	
	var newBullet = bullet.instance()
	newBullet.direction = Vector2.RIGHT.rotated(
		sprite.global_rotation)
	newBullet.speed = 100
	newBullet.damage = damage
	newBullet.global_position = global_position+(
		newBullet.direction*16)
	GameManager.spawnManager.spawn_object(newBullet)
	
	shotsInARow += 1
	
	sprite.scale = Vector2(1.3, .7)
	if shotsInARow >= overheatShotCount:
		currentCooldown = startCooldown
		overheatCooldown.start()
		shotsInARow = 0
		isOn = false
		anim.play("cooldown")
	
	sprite.frame = wrapi(sprite.frame+1, 0, sprite.hframes)
	
	shootSFX.play()

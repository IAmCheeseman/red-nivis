extends Node2D


export var startCooldown:float = 2.3
export var minCooldown:float = .5
export var overheatShotCount:int = 10
export var damage = 5

onready var cooldown = $Cooldown
onready var overheatCooldown = $OverheatCooldown
onready var sprite = $Sprite
onready var anim = $AnimationPlayer

var currentCooldown = 2.3
var shotsInARow = 0
var bullet = preload("res://Enemies/EnemyBullet/EnemyBullet.tscn")


func _ready() -> void:
	currentCooldown = startCooldown


func _process(_delta: float) -> void:
	scale = Vector2.ONE


func shoot():
	if !overheatCooldown.is_stopped() or !cooldown.is_stopped():
		return
	currentCooldown = clamp(currentCooldown*.75, minCooldown, startCooldown)
	cooldown.stop()
	cooldown.start(currentCooldown)
	
	var newBullet = bullet.instance()
	newBullet.direction = Vector2.RIGHT.rotated(sprite.global_rotation)
	newBullet.speed = 180
	newBullet.damage = damage
	newBullet.global_position = global_position+(newBullet.direction*16)
	GameManager.spawnManager.spawn_object(newBullet)
	
	shotsInARow += 1
	if shotsInARow > overheatShotCount:
		currentCooldown = startCooldown
		overheatCooldown.start()
		shotsInARow = 0
		anim.play("cooldown")
	
	sprite.frame = wrapi(sprite.frame+1, 0, sprite.hframes)

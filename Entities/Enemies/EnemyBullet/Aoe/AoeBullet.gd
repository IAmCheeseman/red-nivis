extends "res://Entities/Enemies/EnemyBullet/EnemyBullet.gd"

onready var popSound = $PopSFX
onready var lifetimeTimer = $Lifetime

var minSpeed = speed / 2.5
var scaleMod = scale.x
onready var ogScale = scale
var frict := 5


func _physics_process(delta):
	position += (direction * speed) * delta
	speed = lerp(speed, minSpeed, frict * delta)
	scale = ogScale * scaleMod * (abs(sin(lifetimeTimer.time_left + scaleMod) / 2) + 1)


func _exit_tree() -> void:
	remove_child(popSound)
	GameManager.spawnManager.spawn_object(popSound)
	popSound.play()

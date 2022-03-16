extends "res://Items/Weapons/Bullet/Bullet.gd"

onready var popSound = $PopSFX

var minSpeed = speed / 2.5
var scaleMod = scale.x
var ogScale = scale


func _physics_process(delta):
	position += (direction * speed) * delta
	speed = lerp(speed, minSpeed, 5 * delta)
	trail.hide()
	scale = ogScale * (scaleMod * (abs(sin(lifetimeTimer.time_left + scaleMod)) + .3))


func _exit_tree() -> void:
	remove_child(popSound)
	GameManager.spawnManager.spawn_object(popSound)
	popSound.play()

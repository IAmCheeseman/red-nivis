extends Node2D

onready var anim = $"../../AnimationPlayer"
onready var laserAnim = $AnimationPlayer
onready var parent = $"../.."
onready var sprite = $"../../Sprite"
onready var laser = $Laser
onready var hitbox = $LaserHitbox

var start := false


func test() -> bool:
	start = false
	anim.stop()
	anim.play("LaserPrep")
	sprite.flip_h = parent.player.global_position.x < parent.global_position.x
	return true


func attack(delta: float) -> void:
	parent.vel.x = lerp(parent.vel.x, 0, parent.frict * delta)
	if start:
		anim.play("Laser")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "LaserPrep":
		start = true
		laser.rect_scale.x = -1 if sprite.flip_h else 1
		hitbox.scale.x = laser.rect_scale.x
		laserAnim.play("Shoot")


func stop() -> void:
	laserAnim.stop()
	parent.state = parent.WALK

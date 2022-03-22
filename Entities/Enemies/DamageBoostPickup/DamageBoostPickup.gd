extends KinematicBody2D

onready var sprite = $Sprite
onready var explosion = $Explosion
onready var boostTimer = $DamageBoostTimer
onready var pickupSFX = $PickUpSFX

export var friction := 100.0
export var speed := 100.0
export var incdec := .5

var player = preload("res://Entities/Player/Player.tres")
var vel: Vector2
var toPlayer := false
var disabled := false


func _ready() -> void:
	vel = Vector2.UP.rotated(deg2rad(rand_range(-45, 45))) * speed


func _process(delta: float) -> void:
	if !toPlayer:
		vel = vel.move_toward(Vector2.ZERO, friction * delta)
		toPlayer = vel.is_equal_approx(Vector2.ZERO)
	else:
		vel = vel.move_toward(
			global_position.direction_to(
				player.playerObject.global_position + Vector2(0, -8)
			) * speed,
			friction * delta
		)
		friction += 200 * delta
		speed += 100 * delta

	vel = move_and_slide(vel)


func _on_area_entered(area: Area2D) -> void:
	if sprite.visible and area.is_in_group("player")\
	 and (player.currentMod == self or !player.currentMod):
		GameManager.emit_signal(
			"screenshake",
			1,
			2,
			.025,
			.1
		)
		sprite.hide()
		explosion.emitting = true
		if disabled: return
		player.damageMod = 1 + incdec
		player.attackSpeed = 1 - incdec
		boostTimer.start()
		player.currentMod = self
		pickupSFX.play()


func _on_damage_boost_timeout() -> void:
	if disabled:
		queue_free()
		return
	player.damageMod = 1
	player.attackSpeed = 1
	player.currentMod = null
	queue_free()


func _exit_tree() -> void:
	if disabled: return
	player.damageMod = 1
	player.attackSpeed = 1
	player.currentMod = null

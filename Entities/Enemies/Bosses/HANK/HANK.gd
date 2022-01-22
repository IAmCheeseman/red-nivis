extends KinematicBody2D

onready var player = GameManager.player

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var walkTimer := $Timers/Walk
onready var attackCooldown := $Timers/AttackCooldown

onready var guns = $Sprite/Guns

export var frict := 20
export var attackTimeRange := Vector2(1, 2)
export var speed := 90

var vel := Vector2.ZERO
var target := 0.0

# warning-ignore:unused_signal
signal dead


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	var dir = 1 if global_position.x < target else -1
	sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 5 * delta)
	
	if abs(global_position.x - target) < 5:
		vel.x = lerp(vel.x, 0, frict * delta)
		anim.play("Idle")
		sprite.scale.x *= 1 if GameManager.player.global_position.x < global_position.x else -1
	else:
		vel.x = dir * speed
		anim.play("Walk")
		sprite.scale.x *= -dir
	
	vel.y = move_and_slide(vel).y


func choose_new_target() -> void:
	target = GameManager.player.global_position.x + rand_range(-128, 128)
	if Utils.coin_flip(): target = global_position.x
	walkTimer.start(rand_range(1, 4))


func _on_animation_changed(_old_name: String, _new_name: String) -> void:
	sprite.scale = Vector2(1.3, .7)


func attack() -> void:
	var gunList = guns.get_children()
	for i in gunList.size():
		gunList.shuffle()
		var gun = gunList.pop_front()
		if gun.attack(): break
	attackCooldown.start(rand_range(attackTimeRange.x, attackTimeRange.y))

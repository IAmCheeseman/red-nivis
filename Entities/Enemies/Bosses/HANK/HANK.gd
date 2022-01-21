extends KinematicBody2D

onready var player := GameManager.player

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var moveTimer := $Timers/Move

export var accel := 20
export var speed := 90

var vel := Vector2.ZERO
var target := 0.0


func _ready() -> void:
	target = global_position.x


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	var dir = -1 if target < global_position.x else 1
	if abs(target-global_position.x) < 5:
		vel.x = 0
		anim.play("Idle")
	else:
		vel.x = dir * speed
		anim.play("Walk")
	
	sprite.scale = sprite.scale.abs().move_toward(
		Vector2.ONE, 5 * delta
	)
	sprite.scale.x *= -dir
	
	vel.y = move_and_slide(vel).y


func get_new_target_position() -> void:
	target = GameManager.player.global_position.x + rand_range(-128, 128)
	if rand_range(0, 1) < .05:
		target = global_position.x
	moveTimer.start(rand_range(1, 4))
	#sprite.scale = Vector2(1.2, .8)


func _on_animation_changed(_oldName: String, _newName: String) -> void:
	sprite.scale = Vector2(1.2, .8)

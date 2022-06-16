extends KinematicBody2D

const PLAYER = preload("res://Entities/Player/Player.tres")

onready var sprite = $Sprite
onready var bounceRays = $BounceRays
onready var recallParticles = $RecallParticles

var speed := 450.0

var kicked = false


func _process(_delta: float) -> void:
	if !kicked:
		global_position = PLAYER.playerObject.global_position - Vector2(0, 8)
		look_at(get_global_mouse_position())
		
		sprite.scale.y = 1 if get_global_mouse_position().x > global_position.x else -1
		sprite.position = Vector2(29, 0)
		return
	
	var dir := Vector2.RIGHT.rotated(rotation)
	
	for i in bounceRays.get_children():
		if i.is_colliding():
			dir = dir.bounce(i.get_collision_normal())
			rotation = dir.angle()
			global_position += dir * 4
			break
	
	sprite.position = Vector2.ZERO
	sprite.scale.y = 1 if dir.x > 0 else -1
	
	var _discard = move_and_slide(dir * speed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("melee"):
		kicked = !kicked
		if !kicked:
			recallParticles.restart()

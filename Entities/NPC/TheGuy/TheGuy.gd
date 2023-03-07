extends KinematicBody2D

onready var sprite = $Sprite 
onready var rc = $RayCast2D
onready var landSFX = $LandSFX

var prevGrounded := true
var vel: Vector2
var grabbed := false

func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	
	var mouseClose = get_local_mouse_position().length() < 16
	
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, 2 * delta)
	
	if rc.is_colliding():
		# On ground
		sprite.frame = 0
		sprite.rotation = 0
		vel.x = lerp(vel.x, 0, 5 * delta)
	else:
		# Stretch
		sprite.frame = 1
		sprite.scale.y = clamp((1 / vel.length()) * 275, .5, 1.5)
		sprite.scale.x = (1-sprite.scale.y) + 1 
		sprite.rotation = vel.angle()
		
		# Bounce
		rc.cast_to = vel.normalized() * 8
		rc.force_raycast_update()
		if rc.is_colliding():
			vel = vel.bounce(rc.get_collision_normal()) * .8
			if get_tree().paused: landSFX.play()
	# Casting to the ground
	rc.cast_to = Vector2(0, 12)
	rc.force_raycast_update()
	
	# if we're on the ground, clicking on the slug, emit love particles
	if rc.is_colliding() and !prevGrounded or\
	(Input.is_action_just_pressed("use_item") and mouseClose):
		sprite.scale = Vector2(1.2, .8)
		if get_tree().paused: landSFX.play()
		var newLove = preload("res://Entities/NPC/TheGuy/Love.tscn").instance()
		newLove.emitting = true
		add_child(newLove)
	
	if get_tree().paused:
		# Dragging slug
		if (Input.is_action_pressed("use_item")\
		and (mouseClose and !grabbed))\
		or grabbed:
			vel.y -= Globals.GRAVITY * delta
			vel = vel.move_toward(
				get_local_mouse_position().normalized() * 500,
				1000 * delta
			)
			grabbed = true
		# Chucking slug
		if Input.is_action_just_released("use_item"):
			vel *= 2.5
			grabbed = false
	
	vel.y = move_and_slide(vel).y
	prevGrounded = rc.is_colliding()

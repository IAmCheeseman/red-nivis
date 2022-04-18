extends KinematicBody2D

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRC = $Collisions/FloorDetector
onready var sprite = $Sprite
onready var bazooka = $Sprite/Bazooka
onready var anim = $AnimationPlayer
onready var jumpTimer = $Timers/Jump

export var jumpStrength = 100
export var moveStrength = 30
export var friction = 5

var prevFloorState = true

var vel: Vector2
var targetPos: float

var player: Node


func _process(delta: float) -> void:
	vel.y += Globals.WATER_GRAVITY * delta
	
	if vel.y > 0 and !floorRC.is_colliding():
		sprite.scale.x = clamp(
			1-abs(vel.y/Globals.WATER_GRAVITY),
			.75, 1.5)
		sprite.scale.y = 1+(1-sprite.scale.x)
	elif vel.y < 0 and !floorRC.is_colliding():
		sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 3*delta)
	elif floorRC.is_colliding():
		if !prevFloorState: sprite.scale = Vector2(1.5, .5)
		sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 3*delta)
	
	if !player:
		player = playerDetection.get_player()
		bazooka.player = player
	
	if floorRC.is_colliding():
		vel.x = lerp(vel.x, 0, friction * delta)
		anim.play("Idle")
	sprite.flip_h = vel.x > 0
	
	vel.y = move_and_slide(vel).y
	
	prevFloorState = floorRC.is_colliding()


func jump() -> void:
	jumpTimer.start(rand_range(.5, 3))
	if !floorRC.is_colliding(): return
	
	var dir = Vector2(global_position.x,0).direction_to(Vector2(targetPos,0)).x
	vel = Vector2(dir * moveStrength, -jumpStrength)
	
	sprite.scale = Vector2(0.75, 1.25)


func get_target_pos() -> void:
	if player:
		targetPos = player.global_position.x + rand_range(-128, 128)
	else:
		targetPos = global_position.x + rand_range(-64, 64)

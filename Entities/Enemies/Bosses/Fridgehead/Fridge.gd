extends KinematicBody2D

enum { WANDER, FOOD_SHOOTER }

onready var sprite = $Sprite

export var accel := 50.0
export var speed := 120.0

var player: Node2D

var targetPos: Vector2
var vel: Vector2

var state := WANDER

var offsets = [-80, -96]
var currentOffset = 0


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	get_target_pos()


func _process(delta: float) -> void:
	match state:
		WANDER:
			wander_state(delta)
		FOOD_SHOOTER:
			pass
	
	vel = move_and_slide(vel)


func tilt(delta: float) -> void:
	sprite.rotation_degrees = (vel.x / speed) * 24
	
	


func get_target_pos() -> void:
	var offset = Vector2(rand_range(-64, 64), offsets[currentOffset])
	targetPos = player.global_position + offset
	
	currentOffset = wrapi(currentOffset+1, 0, offsets.size())


func wander_state(delta: float) -> void:
	var actualAccel = accel if global_position.y > targetPos.y else accel * 3
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		actualAccel * delta
	)
	tilt(delta)
	
	if global_position.distance_to(targetPos) < 8:
		get_target_pos()

extends AnimatedSprite

var vel := Vector2.ZERO

export var speed := 150.0
export var accel := 15.0;

var target: Vector2
var targets := []


func _ready() -> void:
	randomize()
	for i in rand_range(2, 5):
		var newTarget = Vector2.RIGHT.rotated(rand_range(0, TAU)) * rand_range(0, 16 * 16)
		targets.append(global_position + newTarget)
	scale = Vector2.ONE * rand_range(0.25, 0.75)
	modulate = Color(scale.x/2, scale.x/2, scale.x/2)


func _process(delta: float) -> void:
	var dir = global_position.direction_to(target)
	vel = vel.move_toward(dir * speed, accel * delta)
	
	position += vel * delta


func get_new_target() -> void:
	target = targets.pop_front()
	targets.append(target)

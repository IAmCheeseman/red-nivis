extends Node2D


export var count := 100
export var range_ := 64
export var speed := 1200.0


var particles := []
var dt:float


func _ready() -> void:
	for i in count:
		particles.append(
		global_position+Vector2.RIGHT\
			.rotated(deg2rad(rand_range(0, 360)))\
			*rand_range(-range_, range_))

func _process(delta: float) -> void:
	update()
	dt = delta

func _draw() -> void:
	for i in particles:
		i += i.direction_to(global_position)*speed*dt
		draw_circle(i-global_position, 3, Color.white)

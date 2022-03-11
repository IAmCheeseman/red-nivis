extends Line2D

const SPRITE_WIDTH = 6

export var size := 8

var pointsGlobal := [global_position+Vector2.RIGHT, global_position]

var lastFrameHead := Vector2.ZERO


func _process(_delta):
#	pointsGlobal[0] -= lastFrameHead-global_position
	
	if pointsGlobal.size() >= 2:
		if global_position.distance_to(pointsGlobal.back()) >= SPRITE_WIDTH:
			pointsGlobal.append(global_position)
	
	while pointsGlobal.size() > size:
		pointsGlobal.pop_front()

	clear_points()
	for point in pointsGlobal:
		add_point(point-global_position)
	
#	add_point(Vector2.ZERO)
	lastFrameHead = global_position

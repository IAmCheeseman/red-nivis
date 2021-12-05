extends Line2D

const SPRITE_WIDTH = 6

export var size := 32

var pointsGlobal := []

func _ready() -> void:
	var pos := Vector2.ZERO
	for i in size:
		add_point(pos)
		pointsGlobal.append(pos)
		pos += Vector2.LEFT * SPRITE_WIDTH


func _process(_delta):
	pointsGlobal.append(global_position)

	while pointsGlobal.size() > size:
		pointsGlobal.pop_front()

	clear_points()
	for point in pointsGlobal:
		add_point(point-global_position)

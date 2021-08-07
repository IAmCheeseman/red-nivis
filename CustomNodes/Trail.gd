extends Line2D
class_name Trail

export var maxLength = 12
export var enabled = true

var pointsGlobal = []


func _process(_delta):
	pointsGlobal.append(global_position)

	while pointsGlobal.size() > maxLength:
		pointsGlobal.pop_front()

	clear_points()
	for point in pointsGlobal:
		add_point(point-global_position)


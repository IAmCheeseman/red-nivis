extends Node2D

export var spinSpeed:float = .5
export var pointCount:int = 8
export var distNear:float = 32
export var distFar:float = 40
export var pointOffsetNear:float = .2
export var pointOffsetFar:float = .15
export var color:Color = Color.white

var points:PoolVector2Array = []

func _ready():
	for i in pointCount:
		points.append(Vector2.RIGHT.rotated(deg2rad(360.0/pointCount)*i))


func _process(delta):
	for point in points.size():
		var angle = spinSpeed*delta
		if Utils.is_even(point): angle *= .5
		points[point] = points[point].rotated(angle)
	update()


func _draw():
	var i = 0
	for point in points:
		var a = .5
		var dist = distNear
		var pointOffset = pointOffsetNear
		if Utils.is_even(i):
			a = .75
			dist = distFar
			pointOffset = pointOffsetFar
		var drawPoints:PoolVector2Array = [point]
		drawPoints.append((Vector2(1, pointOffset).rotated(point.angle()))*dist)
		drawPoints.append((Vector2(1, -pointOffset).rotated(point.angle()))*dist)

		draw_colored_polygon(drawPoints, Color(color.r, color.g, color.b, a))
		i += 1

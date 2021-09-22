extends Node2D

export var targetRadius:float = 1
export var startLineWidth:float = 10
export var time:float = .3

var radius:float = 0
var lineWidth:float = 0
var timer:float = 0


func dothething():
	radius = 0
	lineWidth = 5
	timer = 0


func _process(delta):
	radius = Utils.percentage_of(timer, time)/targetRadius
	lineWidth = (100-Utils.percentage_of(timer, time))/startLineWidth
	radius += startLineWidth-lineWidth
	timer += delta
	if timer > time:
		queue_free()
	update()



func _draw():
	draw_arc(Vector2.ZERO, radius, 0, deg2rad(362), int(360*.5), Color.white, lineWidth, true)

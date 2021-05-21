extends Node2D

export var dist = 16
export var hangTime = .2

var dir : Vector2
var startY : float
var startPos : Vector2
var shellRect : Rect2

onready var sprite = $Sprite

func _ready():
	set_process(false)


func start(direction:Vector2):
	dir = direction
	startY = global_position.y
	startPos = global_position
	sprite.region_rect = shellRect
	set_process(true)


func _process(_delta):
	global_position.y = lerp(global_position.y, startPos.y+dir.y*dist, hangTime)
	global_position.x = lerp(global_position.x, startPos.x+dir.x*dist, hangTime)
	rotation_degrees += 15
	if global_position.is_equal_approx(startPos+(dir*dist)):
		set_process(false)
		rotation_degrees = rand_range(0, 360)
		position = position.round()

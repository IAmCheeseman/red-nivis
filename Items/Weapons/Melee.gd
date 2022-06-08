extends Node2D


onready var timer = $Timer
onready var sprite = $Sprite

export var xTime: Curve
export var maxX := 3
export var time := 5.0

var startY: int
var targetY: int

var startRot: float
var targetRot: float


func _ready() -> void:
	timer.wait_time = time
	timer.start()
	
	startY = sprite.position.y
	targetY = -sprite.position.y
	
	startRot = sprite.rotation
	targetRot = (sprite.rotation * 2) + PI


func _process(delta: float) -> void:
	var diffY = startY - targetY
	var diffRot = targetRot - startRot
	var percentageOver = timer.time_left / timer.wait_time
	diffY *= percentageOver
	diffRot *= percentageOver
	
	sprite.position.y = startY + diffY + (targetY * 2)
	sprite.position.x = -xTime.interpolate(percentageOver) * maxX
	sprite.rotation = startRot + (diffRot + PI)
	
	if Input.is_action_just_pressed("melee"):
		sprite.position.y = startY
		sprite.rotation = startRot
		
		timer.start()

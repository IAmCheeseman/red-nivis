extends Node2D


onready var timer = $Timer
onready var sprite = $Sprite
onready var swish = $Swish
onready var swishStart = $Sprite/SwishStart

export var xTime: Curve
export var maxX := 3
export var time := 5.0
export var maxScaleUp := 0.5

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
	targetRot = (sprite.rotation + PI)


func _process(delta: float) -> void:
	var diffY = startY - targetY
	var diffRot = targetRot - startRot
	var percentageOver = timer.time_left / timer.wait_time
	diffY *= percentageOver
	diffRot *= percentageOver
	
	sprite.position.y = startY + diffY + (targetY * 2)
	sprite.position.x = -xTime.interpolate(percentageOver) * maxX
	sprite.rotation = startRot + (diffRot - PI * 1.5)
	
	var currentScale = sin(PI * percentageOver)
	sprite.scale = Vector2.ONE * (1 + (currentScale * maxScaleUp))
	
	if !percentageOver in [0, 1]:
		swish.add_point(to_local(swishStart.global_position))
		
	swish.position.x -= 100 * delta
	
	if Input.is_action_just_pressed("melee"):
		sprite.position.y = startY
		sprite.rotation = startRot
		swish.position.x = 0
		swish.scale.x = 1
		swish.clear_points()
		
		set_process(false)
		
		yield(TempTimer.timer(self, 1), "timeout")
		
		set_process(true)
		
		timer.start()


func reduce_swish() -> void:
	if swish.get_point_count() - 1 <= 0: return
	swish.remove_point(0)
	swish.remove_point(swish.get_point_count() - 1)

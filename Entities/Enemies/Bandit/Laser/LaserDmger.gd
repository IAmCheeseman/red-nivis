extends Node2D

onready var collChecker = $CollisionChecker
onready var graphics = $TextureRect
onready var collider = $Hitbox/CollisionShape2D

const ACTIVE_COLOR = Color.red
const TELEGRAPH_COLOR = Color.blue

var end := Vector2.ZERO
var active = false
var size := 1.0

func _ready() -> void:
	collider.disabled = true
	hide()
	yield(TempTimer.idle_frame(self), "timeout")
	set_sizes()
	update()
	show()
	collider.disabled = false


func _process(delta: float) -> void:
	if active:
		collider.disabled = false
		size = lerp(size, 0, 4 * delta)
		graphics.rect_scale.y = size
		if size < .05: queue_free()
		if size < .25: collider.disabled = true
	else:
		collider.disabled = true
	set_sizes()
	update()

func _draw() -> void:
	var clr = ACTIVE_COLOR if active else TELEGRAPH_COLOR
	draw_circle(to_local(end), 5 * size, clr)
	draw_circle(Vector2.ZERO, 5 * size, clr)
	graphics.color = clr


func set_sizes() -> void:
	if collChecker.is_colliding(): # hank
		end = collChecker.get_collision_point()
		graphics.rect_size.x = global_position.distance_to(end)
		collider.shape.extents.x = graphics.rect_size.x
		collider.position.x = graphics.rect_size.x / 2


func set_active() -> void:
	active = true
	size = 1.2

extends Node2D

onready var collChecker = $CollisionChecker
onready var graphics = $TextureRect
onready var collider = $Hitbox/CollisionShape2D

var end := Vector2.ZERO
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
	size = lerp(size, 0, 4 * delta)
	graphics.rect_scale.y = size
	if size < .05: queue_free()
	set_sizes()
	update()

func _draw() -> void:
	draw_circle(to_local(end), 5 * size, Color.red)
	draw_circle(Vector2.ZERO, 5 * size, Color.red)


func set_sizes() -> void:
	if collChecker.is_colliding(): # hank
		end = collChecker.get_collision_point()
		graphics.rect_size.x = global_position.distance_to(end)
		collider.shape.extents.x = graphics.rect_size.x
		collider.position.x = graphics.rect_size.x / 2

extends Label

onready var tween = $Tween

var vel := Vector2(0, -75)


func _ready() -> void:
	tween.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		1
	)
	tween.start()


func _physics_process(delta: float) -> void:
	vel.y += 175*delta
	
	rect_position += vel*delta
	


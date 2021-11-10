extends Label

onready var tween = $Tween

var vel := Vector2(0, -75)


func _ready() -> void:
	tween.interpolate_property(
		self, "modulate", modulate.a,
		0, 1)
	tween.start()


func _physics_process(delta: float) -> void:
	vel.y += 115*delta
	
	rect_position += vel*delta
	


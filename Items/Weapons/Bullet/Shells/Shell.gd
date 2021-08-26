extends RigidBody2D

onready var sprite = $Sprite

var direction:Vector2 = Vector2(1, -2).normalized()


func _ready() -> void:
	apply_central_impulse(direction*30)

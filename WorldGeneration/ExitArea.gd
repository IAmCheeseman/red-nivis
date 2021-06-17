extends Area2D

export(int, "UP", "LEFT", "RIGHT", "DOWN") var direction

onready var collision = $CollisionShape2D

var directions = [
	Vector2.UP,
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.DOWN
]

signal move_to_room(direction)


func set_collider(shape:Shape2D):
	collision.shape = shape


func _on_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("move_to_room", directions[direction])

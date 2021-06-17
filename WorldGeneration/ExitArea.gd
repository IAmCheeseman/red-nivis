extends Area2D

export var direction:Vector2

onready var collision = $CollisionShape2D


signal move_to_room(direction)


func set_collider(shape:RectangleShape2D):
	collision.shape = shape


func _on_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("move_to_room", direction)

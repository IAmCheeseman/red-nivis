extends Node2D

onready var hitbox = $Hitbox
onready var collision = $Hitbox/CollisionShape2D

func setup(damage:float, height:float, width:float, rot:float):
	hitbox.damage = damage
	var newShape = RectangleShape2D.new()
	newShape.extents = Vector2(width, height)
	collision.shape = newShape
	rotation_degrees = rot

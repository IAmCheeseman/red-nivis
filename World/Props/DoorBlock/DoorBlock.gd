extends StaticBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D


func position_sprite() -> void:
	var collisionSize = collision.shape.extents
	sprite.rect_position = -collisionSize
	sprite.rect_size = (collisionSize*2).round()
	sprite.rect_size.x = 10

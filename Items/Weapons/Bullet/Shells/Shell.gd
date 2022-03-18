extends RigidBody2D

onready var sprite = $Sprite

var direction:Vector2 = Vector2(1, -2).normalized()


func _ready() -> void:
	apply_central_impulse(direction*30)


func replace_with_sprite() -> void:
	remove_child(sprite)
	GameManager.spawnManager.spawn_object(sprite)
	sprite.rotation = rotation
	sprite.global_position = position
	sprite.modulate *= .5
	sprite.modulate.a = 1
	queue_free()

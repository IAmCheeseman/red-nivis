extends RigidBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D

var direction:Vector2 = Vector2(1, -2).normalized()


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	collision.shape = collision.shape.duplicate()
#	collision.shape.extents = sprite.texture.get_size() / 2
#	collision.position = -collision.shape.extents / 2 
	apply_central_impulse(direction*30)


func replace_with_sprite() -> void:
	remove_child(sprite)
	GameManager.spawnManager.spawn_object(sprite)
	sprite.rotation = stepify(rotation, PI / 2)
	sprite.global_position = position.round()
	sprite.modulate *= .5
	sprite.modulate.a = 1
	queue_free()

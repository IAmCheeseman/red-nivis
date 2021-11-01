extends StaticBody2D

onready var sprite = $Sprite
onready var collision = $CollisionShape2D

export var positionOnReady := false

var targetSize:float = 0


func _ready() -> void:
	if positionOnReady:
		position_sprite()


func _process(delta: float) -> void:
	sprite.rect_size.y = lerp(sprite.rect_size.y, targetSize, 3*delta)


func position_sprite() -> void:
	var collisionSize = collision.shape.extents
	sprite.rect_position = -collisionSize
	targetSize = (collisionSize*2).round().y
	sprite.rect_size.x = 10

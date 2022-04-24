extends Sprite

var speed = 10

func _process(delta: float) -> void:
	position.y -= speed * delta
	speed += speed * delta

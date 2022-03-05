extends Sprite

func _ready() -> void:
	frame = int(round(rand_range(0, hframes-1)))

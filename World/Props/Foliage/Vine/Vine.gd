extends Sprite

func _ready() -> void:
	material = material.duplicate()
	material.set_shader_param("offset", rand_range(-4, 4))

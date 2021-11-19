extends TileMap


func add_timer() -> void:
	var timer = get_tree().create_timer(rand_range(.1, 2))
	timer.connect("timeout", self, "_drop_debris")


func _drop_debris() -> void:
	add_timer()

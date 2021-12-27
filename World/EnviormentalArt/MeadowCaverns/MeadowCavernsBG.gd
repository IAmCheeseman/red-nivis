extends TileMap


func _process(delta: float) -> void:
	var pos = GameManager.currentCamera.global_position
	pos += GameManager.currentCamera.offset
	global_position = pos * 0.025

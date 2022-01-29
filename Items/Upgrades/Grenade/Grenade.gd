extends RigidBody2D


func screenshake() -> void:
	GameManager.emit_signal("screenshake", 3, 6, .15/6, .15)

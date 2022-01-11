extends RigidBody2D


func screenshake() -> void:
	GameManager.emit_signal("screenshake", 3, 12, .025, .15)

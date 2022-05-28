extends KinematicBody2D

var speed := 350
var direction := Vector2.RIGHT


func _physics_process(delta: float) -> void:
	rotation += 3 * delta
	var _discard = move_and_slide(direction)

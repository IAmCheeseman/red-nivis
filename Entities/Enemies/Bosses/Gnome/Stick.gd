extends KinematicBody2D

var speed := 350
var dir := Vector2.RIGHT


func _physics_process(delta: float) -> void:
	dir.y += Globals.GRAVITY*delta
	rotation += 3*delta
	var _discard = move_and_slide(dir)

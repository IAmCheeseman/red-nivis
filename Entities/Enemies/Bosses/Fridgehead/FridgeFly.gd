extends Sprite

onready var area = $Area2D

var targetPos: Vector2
var speed = 10

func _process(delta: float) -> void:
	position = position.move_toward(targetPos, speed * delta)
	speed += speed * delta
	rotation = 0
	
	for i in area.get_overlapping_bodies():
		if i.is_in_group("Fridgehead"):
			look_at(i.global_position)
			rotation -= PI / 2

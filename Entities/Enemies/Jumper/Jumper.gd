extends KinematicBody2D

onready var sprite = $Sprite

onready var playerDetection = $Collision/PlayerDetection

var player: Node2D

func _process(delta: float) -> void:
	if !player:
		player = playerDetection.get_player()
	else:
		update()

func _draw() -> void:
	var pupil = Rect2(
		sprite.position-Vector2.ONE,
		Vector2.ONE*2
	)
	if player:
		pupil = Rect2(
			sprite.position+(Vector2.RIGHT.rotated(
						global_position.direction_to(player.global_position).angle()
					)
				).round()-Vector2.ONE,
			Vector2.ONE*2
		)
	draw_rect(pupil, Color.black)

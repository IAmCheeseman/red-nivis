extends Node2D

onready var sprite = $Sprite

onready var ogPos: float

var player: Node2D

func _ready() -> void:
	ogPos = position.x

func _process(delta: float) -> void:
	if player:
		look_at(player.global_position)
		sprite.flip_v = player.global_position.x < global_position.x
	position.x = -ogPos if $"..".flip_h else ogPos
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, 3 * delta)


func shoot() -> void:
	sprite.scale = Vector2(1.6, 0.4)

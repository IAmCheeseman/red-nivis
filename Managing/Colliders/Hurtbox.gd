extends Area2D
class_name Hurtbox

signal hurt(amount, dir)

var immune = false


func take_damage(amount:float, dir:Vector2) -> void:
	if !immune:
		emit_signal("hurt", amount, dir)
		immune = true

func _process(_delta):
	immune = false
	if Input.is_key_pressed(KEY_I):
		take_damage(1, Vector2.LEFT)

extends Area2D
class_name Hurtbox

signal hurt

func take_damage(amount, dir):
	emit_signal("hurt", amount, dir)

func _process(_delta):
	if Input.is_key_pressed(KEY_I):
		take_damage(1, Vector2.LEFT)

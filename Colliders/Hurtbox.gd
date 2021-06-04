extends Area2D
class_name Hurtbox

export var defense = 0 setget set_defense
export var health = 20

signal dead
signal hurt


func take_damage(amount, dir):
	health -= amount-(defense/2)
	if health <= 0:
		emit_signal("dead")
	else:
		emit_signal("hurt", dir)


func set_defense(value):
	defense = stepify(value, 2)

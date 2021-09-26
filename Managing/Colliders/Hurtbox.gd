extends Area2D
class_name Hurtbox

signal hurt(amount, dir)

onready var immunityTimer = $ImmunityTimer


export var immTime:float = .01

var immune:bool = false


func take_damage(amount:float, dir:Vector2) -> void:
	if immune:
		return
	emit_signal("hurt", amount, dir)
	if immTime > 0:
		immunityTimer.start(immTime)
		immune = true


func _on_immunity_timeout() -> void:
	immune = false

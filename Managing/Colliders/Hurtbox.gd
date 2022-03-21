extends Area2D
class_name Hurtbox

signal hurt(amount, dir)

onready var immunityTimer = $ImmunityTimer


export var immTime:float = -1

var immune:bool = false
var lastHitNode: Node


func take_damage(amount:float, dir:Vector2, hitNode: Node=null) -> void:
	if immune:
		return
	emit_signal("hurt", amount, dir)
	lastHitNode = hitNode
	if immTime > 0:
		immunityTimer.start(immTime)
		immune = true


func _on_immunity_timeout() -> void:
	immune = false

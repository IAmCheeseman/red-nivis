extends Node2D

onready var sprite = $Sprite

var nearEnough = false

signal leverPulled

func _input(event):
	if event.is_action_pressed("interact") and nearEnough:
		emit_signal("leverPulled")
		sprite.frame = 1


func _on_Collision_area_entered(area):
	if area.is_in_group("player"):
		nearEnough = true


func _on_Collision_area_exited(area):
	if area.is_in_group("player"):
		nearEnough = false

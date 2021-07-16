extends Node2D

onready var sprite = $Sprite

var nearEnough = false

signal leverPulled

func _input(event):
	if event.is_action_pressed("interact") and nearEnough:
		flip()

func flip():
	if sprite.frame == 0:
		emit_signal("leverPulled")
	sprite.frame = wrapi(sprite.frame+1, 0, 2)

func _on_Collision_area_entered(area):
	if area.is_in_group("player"):
		nearEnough = true
	elif area.is_in_group("playerBullet"):
		flip()

func _on_Collision_area_exited(area):
	if area.is_in_group("player"):
		nearEnough = false

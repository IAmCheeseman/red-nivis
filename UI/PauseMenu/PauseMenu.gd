extends Control

export var useable = true

func _ready():
	hide()
	if !useable: queue_free()


func _input(event):
	if event.is_action_pressed("pause") and !GameManager.inGUI:
		visible = !visible
		get_tree().paused = visible


func _on_continue_pressed():
	hide()
	get_tree().paused = false


func _on_quittm_pressed():
	Resetter.reset()
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func _on_quittd_pressed():
	get_tree().quit()

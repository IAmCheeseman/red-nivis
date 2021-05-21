extends Control


func _ready():
	hide()


func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = visible


func _on_continue_pressed():
	hide()
	get_tree().paused = false


func _on_quittm_pressed():
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_quittd_pressed():
	get_tree().quit()

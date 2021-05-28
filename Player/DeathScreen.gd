extends VBoxContainer


func _on_Continue_button_up():
	GameManager.isDead = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Quit_button_up():
	var isOK = get_tree().change_scene("res://UI/MainMenu.tscn")

	if isOK != OK:
		get_tree().quit()

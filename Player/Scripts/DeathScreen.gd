extends VBoxContainer


func _on_Continue_button_up():
	GameManager.isDead = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Quit_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_QuitDesktop_pressed():
	get_tree().quit()

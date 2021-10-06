extends VBoxContainer

var playerData = preload("res://Entities/Player/Player.tres")


func _on_Continue_button_up():
	playerData.isDead = false
	playerData.health = playerData.maxHealth
	playerData.ammo = playerData.maxAmmo
	Engine.time_scale = 1
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_Quit_button_up():
	playerData.isDead = false
	playerData.health = playerData.maxHealth
	playerData.ammo = playerData.maxAmmo
	Engine.time_scale = 1
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func _on_QuitDesktop_pressed():
	get_tree().quit()

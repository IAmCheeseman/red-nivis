extends VBoxContainer

var playerData = preload("res://Entities/Player/Player.tres")
var inventory = preload("res://UI/Inventory/Inventory.tres")
var worldData = preload("res://World/WorldManagement/WorldData.tres")


func _on_Continue_button_up():
	Resetter.reset()

# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func _on_Quit_button_up():
	Resetter.reset()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func _on_QuitDesktop_pressed():
	get_tree().quit()

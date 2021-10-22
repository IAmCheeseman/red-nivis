extends VBoxContainer

var playerData = preload("res://Entities/Player/Player.tres")
var inventory = preload("res://UI/Inventory/Inventory.tres")
var worldData = preload("res://World/WorldManagement/WorldData.tres")


func _on_Continue_button_up():
	inventory.setup()
	playerData.isDead = false
	playerData.health = playerData.maxHealth
	playerData.ammo = playerData.maxAmmo
	Engine.time_scale = 1

# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")


func _on_Quit_button_up():
	inventory.setup()
	playerData.isDead = false
	playerData.health = playerData.maxHealth
	playerData.ammo = playerData.maxAmmo
	Engine.time_scale = 1
	
	randomize()
	worldData.generate_world()
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/UpgradeSelection/UpgradeSelection.tscn")


func _on_QuitDesktop_pressed():
	get_tree().quit()

extends Control

var dataManager = DataManager.new()


func _on_Play_pressed():
	var settings = {
		"screenshake"  : Settings.screenshake,
		"mist"         : Settings.mistEnabled,
		"keybinds"     : Settings.keybinds
	}
	dataManager.save_data(settings, "save.dat")
	hide()
	get_parent().get_node("Buttons").show()



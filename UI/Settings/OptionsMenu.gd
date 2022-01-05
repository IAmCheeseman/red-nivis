extends Control

var dataManager = DataManager.new()


func _on_Play_pressed():
	var settings = {
		"graphicsQuality" : Settings.graphicsQuality,
		"vsync"           : Settings.vsync,
		"maxfps"          : Settings.maxfps,
		"screenshake"     : Settings.screenshake,
		"brightness"      : Settings.brightness,
		"difficulty"      : Settings.difficulty,
		"keybinds"        : Settings.keybinds,
		"masterVol"       : Settings.masterVol,
		"sfx"             : Settings.sfx,
		"music"           : Settings.music
	}
	
	dataManager.save_data(settings, "settings.dat")
	hide()
	get_parent().get_node("Buttons").show()


func update_settings() -> void:
	Engine.target_fps = Settings.maxfps
	OS.vsync_enabled  = Settings.vsync
	AudioServer.set_bus_volume_db(0, linear2db(Settings.masterVol))
	AudioServer.set_bus_volume_db(3, linear2db(Settings.sfx))


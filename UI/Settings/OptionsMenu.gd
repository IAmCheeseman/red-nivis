extends Control

var dataManager = DataManager.new()


func _on_quit():
	update_settings()
	
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
	# Saving the data
	dataManager.save_data(settings, "settings.dat")


func update_settings() -> void:
	Engine.target_fps = Settings.maxfps
	OS.vsync_enabled  = Settings.vsync
	AudioServer.set_bus_volume_db(0, linear2db(Settings.masterVol))
	AudioServer.set_bus_volume_db(3, linear2db(Settings.sfx))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): hide()

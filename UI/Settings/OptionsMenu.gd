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



func _on_graphic_quality_changed() -> void:
	Settings.graphicsQuality = find_node("GraphicalQuality").selectedIdx
func _on_screenshake_value_changed(value: float) -> void:
	Settings.screenshake = value / 100
func _on_vsync_pressed() -> void:
	Settings.vsync = find_node("VSync").selected == "On"
func _on_framerate_value_changed(value) -> void:
	Settings.maxfps = value
	if value == 145: Settings.maxfps = -1
func _on_difficulty_pressed() -> void:
	Settings.difficulty = find_node("Difficulty").selectedIdx
func _on_master_volume_value_changed(value) -> void:
	Settings.masterVol = value / 100
func _on_sfx_volume_value_changed(value) -> void:
	Settings.sfx = value / 100
func _on_music_volume_value_changed(value) -> void:
	Settings.music = value / 100

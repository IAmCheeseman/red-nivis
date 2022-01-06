extends Control

var dataManager = DataManager.new()

onready var menus = $Menus
onready var navMenu = $NavMenu


func _ready() -> void:
	set_values()


func _on_quit():
	update_settings()
	
	var settings = {
		"maxfps"          : Settings.maxfps,
		"screenshake"     : Settings.screenshake,
		"brightness"      : Settings.brightness,
		"keybinds"        : Settings.keybinds,
		"masterVol"       : Settings.masterVol,
		"sfx"             : Settings.sfx,
		"music"           : Settings.music
	}
	# Saving the data
	dataManager.save_data(settings, Globals.SETTINGS_FILE_NAME)
	
	for i in menus.get_children():
		i.hide()
	navMenu.show()


func update_settings() -> void:
	Engine.target_fps = Settings.maxfps
	AudioServer.set_bus_volume_db(0, linear2db(Settings.masterVol))
	AudioServer.set_bus_volume_db(3, linear2db(Settings.sfx))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		hide()
		_on_quit()



func _on_graphic_quality_changed() -> void:
	Settings.graphicsQuality = wrapi(find_node("GraphicalQuality").selectedIdx+1, 0, 2)
func _on_screenshake_value_changed(value: float) -> void:
	Settings.screenshake = value / 100
func _on_framerate_value_changed(value) -> void:
	Settings.maxfps = value
	if value == 145: Settings.maxfps = -1
func _on_master_volume_value_changed(value) -> void:
	Settings.masterVol = value / 100
func _on_sfx_volume_value_changed(value) -> void:
	Settings.sfx = value / 100
func _on_music_volume_value_changed(value) -> void:
	Settings.music = value / 100


func set_values() -> void:
	find_node("Screenshake").get_node("HSlider").value = Settings.screenshake * 100
	find_node("Framerate").get_node("HSlider").value = Settings.maxfps
	if Settings.maxfps == -1: find_node("Screenshake").get_node("HSlider").value = 145
	find_node("MSTRVolume").get_node("HSlider").value = Settings.masterVol * 100
	find_node("SFXVolume").get_node("HSlider").value = Settings.sfx * 100
	find_node("MSXVolume").get_node("HSlider").value = Settings.music * 100

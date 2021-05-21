extends Control

var dataManager = DataManager.new()


func _ready():
	var settingsData = dataManager.load_data("save.dat")
	
	var validSettingsKey = [
		"screenshake",
		"cameraLook",
		"vignette",
		"pixelPerfect",
		"playerTilt"
	]
	
	if settingsData and settingsData.keys() == validSettingsKey:
		Settings.cameraLook = settingsData.cameraLook
		Settings.vignette = settingsData.vignette
		Settings.pixelPerfect = settingsData.pixelPerfect
		Settings.screenshake = settingsData.screenshake
		Settings.playerTilt = settingsData.playerTilt
	
	$Center/VBoxContainer/HBoxContainer/Buttons/PixelPerfect.pressed = Settings.pixelPerfect
	$Center/VBoxContainer/HBoxContainer/Buttons/Vignette.pressed = Settings.vignette
	$Center/VBoxContainer/HBoxContainer/Sliders/Screenshake/HSlider.value = Settings.screenshake
	$Center/VBoxContainer/HBoxContainer/Sliders/CameraLook/HSlider.value = Settings.cameraLook
	$Center/VBoxContainer/HBoxContainer/Buttons/PlayerTilt.pressed = Settings.playerTilt
	
	$Center/VBoxContainer/Back.set_focus_mode(Control.FOCUS_NONE)


func _on_screenshake_value_changed(value):
	Settings.screenshake = value


func _on_cameralook_value_changed(value):
	Settings.cameraLook = value


func _on_PixelPerfect_toggled(button_pressed):
	Settings.pixelPerfect = button_pressed


func _on_Vignette_toggled(button_pressed):
	Settings.vignette = button_pressed


func _on_PlayerTilt_toggled(button_pressed):
	Settings.playerTilt = button_pressed


func _on_Play_pressed():
	var settings = {
		"screenshake"  : Settings.screenshake,
		"cameraLook"   : Settings.cameraLook,
		"vignette"     : Settings.vignette,
		"pixelPerfect" : Settings.pixelPerfect,
		"playerTilt"   : Settings.playerTilt
	}
	dataManager.save_data(settings, "save.dat")
	hide()
	get_parent().get_node("Buttons").show()



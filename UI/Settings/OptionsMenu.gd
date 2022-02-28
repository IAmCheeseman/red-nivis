extends Control

var dataManager = DataManager.new()

onready var menus = $Menus
onready var navMenu = $NavMenu
onready var keybinds = $Menus/Keybinds/Scroll/VBox
onready var BGgradient = find_node("Gradient")
onready var BG = $BG
onready var backButton = $NavMenu/Back


func _ready() -> void:
	update_settings()
	set_values()


func _process(_delta: float) -> void:
	BGgradient.rect_position.x = BG.rect_position.x + BG.rect_size.x


func _on_quit():
	update_settings()
	
	var settings = {
		"gfx"              : Settings.gfx,
		"fullscreen"       : Settings.fullscreen,
		"maxfps"           : Settings.maxfps,
		"screenshake"      : Settings.screenshake,
		"brightness"       : Settings.brightness,
		"keybinds"         : Settings.keybinds,
		"masterVol"        : Settings.masterVol,
		"sfx"              : Settings.sfx,
		"music"            : Settings.music,
		"speedrunTimer"    : Settings.speedrunTimer,
		"doubleDamageMode" : Settings.doubleDamageMode,
		"lang"             : Settings.lang
	}
	# Saving the data
	dataManager.save_data(settings, Globals.SETTINGS_FILE_NAME)
	
	for i in menus.get_children():
		i.hide()
	navMenu.show()


func update_settings() -> void:
	OS.window_fullscreen = Settings.fullscreen
	Engine.target_fps = Settings.maxfps
	AudioServer.set_bus_volume_db(0, linear2db(Settings.masterVol))
	AudioServer.set_bus_volume_db(3, linear2db(Settings.sfx))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		backButton.change_menu()
		_on_quit()


func _on_fullscreen_toggled(buttonPressed: bool) -> void:
	Settings.fullscreen = buttonPressed
func _on_graphic_quality_changed(buttonPressed: bool) -> void:
	Settings.gfx = Settings.GFX_BAD if buttonPressed else Settings.GFX_GOOD
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
func _on_speedrun_mode_toggled(button_pressed: bool) -> void:
	Settings.speedrunTimer = button_pressed
func _on_double_damage_toggled(button_pressed: bool) -> void:
	Settings.doubleDamageMode = button_pressed
func _on_english_pressed() -> void:
	Settings.change_lang("en")
func _on_spanish_pressed() -> void:
	Settings.change_lang("es")
func _on_british_pressed() -> void:
	Settings.change_lang("en_GB")
func _on_german_pressed() -> void:
	Settings.change_lang("de")


func set_values() -> void:
	find_node("Fullscreen").pressed = Settings.fullscreen
	find_node("GFX").pressed = Settings.gfx == Settings.GFX_BAD
	find_node("SpeedrunMode").pressed = Settings.speedrunTimer
	find_node("DoubleDamage").pressed = Settings.doubleDamageMode
	find_node("Screenshake").get_node("HSlider").value = Settings.screenshake * 100
	find_node("Framerate").get_node("HSlider").value = Settings.maxfps
	if Settings.maxfps == -1: find_node("Screenshake").get_node("HSlider").value = 145
	find_node("MSTRVolume").get_node("HSlider").value = Settings.masterVol * 100
	find_node("SFXVolume").get_node("HSlider").value = Settings.sfx * 100
	find_node("MSXVolume").get_node("HSlider").value = Settings.music * 100


func _on_reset_kb_bindings_pressed() -> void:
	for i in keybinds.get_children():
		if i.has_method("reset"): i.reset()






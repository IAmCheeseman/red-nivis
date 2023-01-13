extends Control

onready var menus = $Menus
onready var navMenu = $Center/NavMenu
onready var keybinds = $Menus/Keybinds/VBox
onready var BG = $BG
onready var backButton = $Center/NavMenu/Back

var settingVals = true
var wasVisible = false

func _ready() -> void:
	update_settings()
	set_values()

func _process(delta: float) -> void:
	if visible != wasVisible:
		set_values()
	wasVisible = visible

func _menu_change() -> void:
	update_settings()
	Settings.save_settings()

func _on_quit() -> void:
	update_settings()
	Settings.save_settings()

	for i in menus.get_children():
		i.hide()
	navMenu.show()


func update_settings() -> void:
	OS.window_fullscreen = Settings.fullscreen
	Engine.target_fps = Settings.maxfps
	OS.vsync_enabled = Settings.vsync
	AudioServer.set_bus_volume_db(0, linear2db(Settings.masterVol))
	AudioServer.set_bus_volume_db(2, linear2db(Settings.music))
	AudioServer.set_bus_volume_db(3, linear2db(Settings.sfx))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		backButton.change_menu()
		_on_quit()

func _on_fullscreen_toggled(buttonPressed: bool) -> void:
	Settings.fullscreen = buttonPressed
func _on_vsync_toggled(buttonPressed: bool) -> void:
	Settings.vsync = buttonPressed
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
func _on_tutorial_toggled(button_pressed: bool) -> void:
	load("res://Entities/Player/Player.tres").tutorialEnabled = button_pressed
func _on_english_pressed() -> void:
	Settings.change_lang("en")
func _on_spanish_pressed() -> void:
	Settings.change_lang("es_VE")
func _on_british_pressed() -> void:
	Settings.change_lang("en_GB")
func _on_german_pressed() -> void:
	Settings.change_lang("de")


func set_values() -> void:
	find_node("Fullscreen").pressed = OS.window_fullscreen
	find_node("GFX").pressed = Settings.gfx == Settings.GFX_BAD
	find_node("SpeedrunMode").pressed = Settings.speedrunTimer
	find_node("DoubleDamage").pressed = Settings.doubleDamageMode
	find_node("Screenshake").get_node("HSlider").value = Settings.screenshake * 100
	if Settings.maxfps == -1: find_node("Screenshake").get_node("HSlider").value = 145
	else: find_node("Framerate").get_node("HSlider").value = Settings.maxfps
	find_node("MSTRVolume").get_node("HSlider").value = Settings.masterVol * 100
	find_node("SFXVolume").get_node("HSlider").value = Settings.sfx * 100
	find_node("MSXVolume").get_node("HSlider").value = Settings.music * 100
	find_node("VSync").pressed = Settings.vsync


func _on_reset_kb_bindings_pressed() -> void:
	for i in keybinds.get_children():
		if i.has_method("reset"): i.reset()


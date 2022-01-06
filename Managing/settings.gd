extends Node


func _init() -> void:
	var dm := DataManager.new()
	var settings := dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	if settings == {}: # Checking if I need to create save files
		save_defaults(dm)
		settings = dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	for i in settings.keys(): # Applying save
		if !get(i): continue
		set(i, settings[i])
	if settings.has("keybinds"): keybinds = settings.keybinds
	
	for i in keybinds.keys(): # Applying keybinds 
		var newKey = InputEventKey.new() 
		newKey.scancode = OS.find_scancode_from_string(keybinds[i])
		InputMap.action_erase_events(i)
		InputMap.action_add_event(i, newKey)


func save_defaults(dm: DataManager) -> void:
	var ok = dm.save_data({
		"maxfps"          : Settings.maxfps,
		"screenshake"     : Settings.screenshake,
		"brightness"      : Settings.brightness,
		"keybinds"        : Settings.keybinds,
		"masterVol"       : Settings.masterVol,
		"sfx"             : Settings.sfx,
		"music"           : Settings.music
	}, Globals.SETTINGS_FILE_NAME)
	if ok != OK: assert(false, "lmao time for pain")

# Graphics

# Performance
var maxfps := 60

# Purely visual
var screenshake := 1.0
var brightness := 1.0


# Gameplay

var keybinds := {}
var controllerKeybinds := {}

# Audio

var masterVol := 1.0
var sfx := 1.0
var music := 1.0

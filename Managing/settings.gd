extends Node

enum {GFX_BAD, GFX_GOOD}

func _init() -> void:
	var dm := DataManager.new()
	var settings := dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	if settings == {}: # Checking if I need to create save files
		save_defaults(dm)
		settings = dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	print("---- SETTINGS ----")
	for i in settings.keys(): # Applying save
		if get(i) == null: continue
		var disp = "{Dictionary}" if settings[i] is Dictionary else "[Array]" if settings[i] is Array else settings[i]
		print("%s = %s" % [i, disp])
		set(i, settings[i])
	
	var defaults = InputMap.get_actions()
	for i in defaults:
		var action = InputMap.get_action_list(i)
		if action.size() == 0: continue
		defaultKeybinds[i] = action[0]
	
	for i in keybinds.keys(): # Applying keybinds 
		var newKey = InputEventKey.new() 
		newKey.scancode = OS.find_scancode_from_string(keybinds[i])
		InputMap.action_erase_events(i)
		InputMap.action_add_event(i, newKey)


func save_defaults(dm: DataManager) -> void:
	var ok = dm.save_data({
		"gfx"             : gfx,
		"fullscreen"      : fullscreen,
		"maxfps"          : maxfps,
		"screenshake"     : screenshake,
		"brightness"      : brightness,
		"keybinds"        : keybinds,
		"masterVol"       : masterVol,
		"sfx"             : sfx,
		"music"           : music
	}, Globals.SETTINGS_FILE_NAME)
	if ok != OK: assert(false, "lmao time for pain")

# Graphics
var gfx := GFX_GOOD
var fullscreen := OS.has_feature("standalone")

# Performance
var maxfps := 60

# Purely visual
var screenshake := 1.0
var brightness := 1.0


# Gameplay

var keybinds           := {}
var defaultKeybinds    := {}
var controllerKeybinds := {}

# Audio

var masterVol := 1.0
var sfx := 1.0
var music := 1.0

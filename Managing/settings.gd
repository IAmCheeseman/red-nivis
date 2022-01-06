extends Node

enum {GRAPHICS_LOW=0, GRAPHICS_NORMAL=1}
enum {DIFF_NORMAL=0, DIFF_HARD=1}


func _init() -> void:
	var dm := DataManager.new()
	var settings := dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	if settings == {}: # Checking if I need to create save files
		save_defaults(dm)
		settings = dm.load_data(Globals.SETTINGS_FILE_NAME)
	
	print(settings)
	for i in settings.keys(): # Applying save
		if !get(i): continue
		set(i, settings[i])


func save_defaults(dm: DataManager) -> void:
	dm.save_data({
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
	}, Globals.SETTINGS_FILE_NAME)

# Graphics

# Performance
var graphicsQuality := GRAPHICS_NORMAL
var vsync := true
var maxfps := 60

# Purely visual
var screenshake := 1.0
var brightness := 1.0


# Gameplay

var difficulty := DIFF_NORMAL

var keybinds := {}
var controllerKeybinds := {}

# Audio

var masterVol := 1.0
var sfx := 1.0
var music := 1.0

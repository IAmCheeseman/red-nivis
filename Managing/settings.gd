extends Node

enum {GRAPHICS_LOW, GRAPHICS_NORMAL, GRAPHICS_HIGH}
enum {DIFF_EASY, DIFF_NORMAL, DIFF_HARD}

# Graphics

# Performance
var graphicsQuality := GRAPHICS_NORMAL
var lightingEffects := true
var vsync := true
var maxfps := -1

# Purely visual
var screenshake := 1.0
var brightness := 1.0

# Gameplay
var difficulty := DIFF_NORMAL

var keybinds := {}
var controllerKeybinds := {}

# Audio
var sfx := 1.0
var music := 1.0

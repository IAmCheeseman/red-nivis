extends Node

enum {GRAPHICS_LOW, GRAPHICS_NORMAL, GRAPHICS_HIGH}
enum {DIFF_UNPAINFUL, DIFF_PAIN, DIFF_MORE_PAIN, DIFF_PAIN_ON_STEROIDS}

# Graphics
var graphicsQuality := GRAPHICS_NORMAL
var screenshake := 1.0

# Gameplay
var difficulty = DIFF_PAIN
var keybinds = {}

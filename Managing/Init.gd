extends Node2D

var subtitles = [
	"I ate a burger.",
	"Spaghetti code is my passion.",
	"Looks like someone needs to lose a couple pounds :eyes:",
	"Go hydrate, you coward!",
	"Go take a shower!",
	"https://discord.gg/v99ryga",
	"Ur dewin gr8!",
	"You cahn dew eet!",
	"The best top down shooter.",
	"lmao",
	"lol",
	"Who took my pickles?",
	"I like my pasta how I like my code."
]


func _ready():
	randomize()
	
	var playerData = preload("res://Player/Player.tres")
	playerData.health = playerData.maxHealth
	playerData.ammo = playerData.maxAmmo
	
	subtitles.shuffle()
	OS.set_window_title("Astronaut Game: %s" % subtitles.front())

# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")

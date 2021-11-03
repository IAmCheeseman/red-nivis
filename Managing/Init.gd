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

	if OS.get_name() == "OSX":
		Engine.target_fps = 16
	
	subtitles.shuffle()
	OS.set_window_title("Astronaut Game: %s" % subtitles.front())
	
	var _dispose = get_tree().change_scene("res://UI/UpgradeSelection/UpgradeSelection.tscn")

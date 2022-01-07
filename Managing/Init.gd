extends Node2D

var subtitles = [
	"I ate a burger.",
	"Spaghetti code is my passion.",
	"Looks like someone needs to lose a couple pounds👀 ",
	"Go hydrate, you coward!",
	"Go take a shower!",
	"https://discord.gg/v99ryga",
	"Ur dewin gr8!",
	"You cahn dew eet!",
	"The best top down shooter.",
	"lmao",
	"lol",
	"Who took my pickles?",
	"I like my pasta how I like my code.",
	"By Cheeseman",
	"Yoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo",
	"Literal chad",
	"https://open.spotify.com/track/4erUdYkM8wlFLlnUy7Jn0A?si=6ca8f6679721456e",
	"Could you not?"
]

const STARTING_AREA = "res://World/StartingArea/StartingArea.tscn"
const RUN = "res://World/WorldManagement/World.tscn"


func _ready():
	randomize()
	
	subtitles.shuffle()
	OS.set_window_title("Astronaut Game: %s" % subtitles.front())
	if OS.get_name() == "OSX":
		OS.set_window_title("Astronaut Game: Stop using MacOS and use Linux lmao")
	
	if OS.has_feature("standalone"):
		OS.set_window_always_on_top(false)
	
	var runLoaded = GameManager.load_run()
	
	if runLoaded == OK:
		var _discard = get_tree().change_scene(RUN)
		return
	var _discard = get_tree().change_scene(STARTING_AREA)

extends Node2D

var subtitles = [
	"I ate a burger.",
	"Spaghetti code is my passion.",
	"Looks like someone needs to lose a couple pounds :eyes:",
	"Go hydrate, you coward!",
	"Go take a shower!",
	"https://discord.gg/v99ryga",
	"Ur dewin gr8!"
]


func _ready():
	randomize()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")
	
	subtitles.shuffle()
	OS.set_window_title("Astronaut Game: %s" % subtitles.front())

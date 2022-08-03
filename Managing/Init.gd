extends Node2D


var titles = [
	"Astronaut Game",
	"The Video Game",
	"The Movie",
	"The One and Only",
	"Pilot Episode",
	"Episode 1",
	"The Beginning",
	"The First",
]

func _ready():
	randomize()
	titles.shuffle()

	OS.set_window_title("Red Nivis: %s" % titles.front())
	OS.window_fullscreen = Settings.fullscreen

	print("Steam is working: %s" % Steam.is_init())

	Achievement.unlock("PARTICIPATE")

	var _discard = get_tree().change_scene("res://UI/MainMenu/LogoFlash.tscn")

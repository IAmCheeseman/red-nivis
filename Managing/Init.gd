
extends Node2D


var titles = [
	"Astronaut Game",
	"The Video Game",
	"The Movie",
	"The One and Only",
	"The Sequal",
	"The Unconfirmed Sequal",
	"The Prequal",
	"The Sequal's Sequal",
	"The Sequal's Sequal's Prequal's Prequal",
	"The Sequal's Prequal",
	"The Prequal's Prequal",
	"The Prequal's Sequal",
	"The Follow-Up",
	"The Follow-Up's Follow-Up",
	"Pilot Episode",
	"Episode 1",
	"Episode 2",
	"Episode 4",
	"The Beginning",
	"The Middle",
	"The Ending",
	"The First",
	"The Second",
	"The Third",
]


func _ready():
	randomize()
	titles.shuffle()
	
	OS.set_window_title("Red Nivis: %s" % titles.front())
	OS.window_fullscreen = Settings.fullscreen
	
	print("Steam is working: %s" % Steam.is_init())
	
	Achievement.unlock("PARTICIPATE")
	
	var _discard = get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")

extends Node2D


var titles = [
	"I love playing with the title",
	"Astronaut Game",
	"Pasta Edition",
	"When the",
	"Explosions (BOOM)",
	"Cheeseman's Creation",
	"Dot32IsCool",
	"6AM",
	"Bacon",
	"B E A N",
	"The Video Game",
	"The One And Only",
	"The Movie",
	"The Sequal",
	"The Prequal",
	"The Sequal's Sequal",
	"The Sequal's Prequal",
	"The Prequal's Prequal",
	"The Prequal's Sequal",
	"The Follow-Up",
	"The Follow-Up's Follow-Up",
	"The Beginning",
	"The Ending",
	"The First",
	"The Onest",
	"The Second",
	"The Twond",
	"The Third",
	"The Threed",
	"Lmao.",
	". (That's a period (Full-stop))",
	"What."
]


func _ready():
	randomize()
	titles.shuffle()
	OS.set_window_title("Red Nivis: %s" % titles.front())
	OS.window_fullscreen = Settings.fullscreen
	
	var _discard = get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")

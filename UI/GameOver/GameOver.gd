extends VBoxContainer

onready var score = find_node("Score")
onready var highScore = find_node("HighScore")
onready var kills = find_node("Kills")
onready var time = find_node("Time")


func _ready() -> void:
	update_stats()
	hide()


func update_stats() -> void:
	var playerData = preload("res://Entities/Player/Player.tres")
	kills.bbcode_text = "[center]Kills\n[color=red]%s" % playerData.kills
	score.bbcode_text = "[center]Score\n[color=yellow]%s" % playerData.score
	
	var seconds = int(playerData.time) % 60
	var minutes = int(playerData.time) % 3600 / 60
	time.bbcode_text = "[center]Time\n[color=green]%s:%s" % [minutes, seconds]

func _on_continue_button_up():
	Resetter.reset()
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")

func _on_quit_pressed():
	get_tree().quit()

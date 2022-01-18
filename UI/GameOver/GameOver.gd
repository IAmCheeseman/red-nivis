extends VBoxContainer

onready var score = find_node("Score")
onready var highScore = find_node("HighScore")
onready var kills = find_node("Kills")
onready var time = find_node("Time")


func _ready() -> void:
	update_stats()
#	hide()


func update_stats() -> void:
	var playerData = preload("res://Entities/Player/Player.tres")
	kills.bbcode_text = "[center]Kills\n----\n[color=red]%s" % playerData.kills
	score.bbcode_text = "[center]Score\n----\n[color=yellow]%s" % playerData.score
	
	var seconds = str(int(playerData.time) % 60)
	if seconds.length() == 1: seconds = "0"+seconds
	var minutes = str(int(playerData.time) % 3600 / 60)
	time.bbcode_text = "[center]Time\n----\n[color=green]%s:%s" % [minutes, seconds]
	
	highScore.bbcode_text = "[center]High Score\n----\n[color=purple]%s" % playerData.highScore


func _on_continue_button_up():
	Resetter.reset()
	get_tree().change_scene("res://World/StartingArea/StartingArea.tscn")

func _on_quit_pressed():
	get_tree().quit()

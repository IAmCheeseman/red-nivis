extends VBoxContainer

onready var score = find_node("Score")
onready var highScore = find_node("HighScore")
onready var kills = find_node("Kills")
onready var time = find_node("Time")
onready var leaderboard = $CanvasLayer/Leaderboard

export var continueScene := "res://World/StartingArea/StartingArea.tscn"


func _ready() -> void:
	update_stats()
	hide()


func update_stats() -> void:
	var playerData = preload("res://Entities/Player/Player.tres")
	
	kills.bbcode_text = "[center]Kills\n[color=red]%s" % playerData.kills
	score.bbcode_text = "[center]Score\n[color=yellow]%s" % playerData.score
	
	var seconds = str(int(playerData.time) % 60)
	if seconds.length() == 1: seconds = "0"+seconds
# warning-ignore:integer_division
	var minutes = str(int(playerData.time) % 3600 / 60)
# warning-ignore:integer_division
	time.bbcode_text = "[center]Time\n[color=green]%s:%s" % [minutes, seconds]
	
	playerData.highScore = max(playerData.highScore, playerData.score)
	highScore.bbcode_text = "[center]High Score\n[color=purple]%s" % playerData.highScore
	
	GameManager.save_game()


func _on_continue_button_up():
	Resetter.reset()
	var _discard = get_tree().change_scene(continueScene)

func _on_quit_pressed():
	get_tree().quit()


func _on_leaderboards_pressed() -> void:
	leaderboard.show()
	leaderboard.update_leaderboard()

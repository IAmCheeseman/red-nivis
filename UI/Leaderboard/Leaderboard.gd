extends Control

onready var globalScores = $Lists/Global
onready var friendScores = $Lists/Friends
onready var label = $Lists/Friends/Label

var playerData = preload("res://Entities/Player/Player.tres")


func update_leaderboard() -> void:
	Steam.set_leaderboard_score("Score", playerData.highScore)
	var playerScoreGlobal = yield(
		Steam.get_leaderboard_scores(
			"Score", -1, 1, Steam.LeaderboardDataRequest.GlobalAroundUser
		),
		"done"
	)
	for i in globalScores.get_children():
		if i.name == "Title" or i == label: continue
		i.queue_free()
	for i in friendScores.get_children():
		if i.name == "Title" or i == label: continue
		i.queue_free()
	
	for i in playerScoreGlobal:
		var newLabel = label.duplicate()
		newLabel.show()
		newLabel.bbcode_text = "[color=gray]#%s - [/color]%s  [color=gray]|[/color]  [color=yellow]%s[/color]" % [i.global_rank, i.persona_name, i.score]
		globalScores.add_child(newLabel)
	
	var playerScoreFriends = yield(
		Steam.get_leaderboard_scores(
			"Score", -1, 1, Steam.LeaderboardDataRequest.Friends
		),
		"done"
	)
	for i in playerScoreFriends:
		var newLabel = label.duplicate()
		newLabel.show()
		newLabel.bbcode_text = "[color=gray]#%s - [/color]%s  [color=gray]|[/color]  [color=yellow]%s[/color]" % [i.global_rank, i.persona_name, i.score]
		friendScores.add_child(newLabel)


func _on_back_pressed() -> void:
	hide()

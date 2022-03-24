extends Control

onready var globalScores = $Lists/GlobalLeaderboard/Margin/Scores

var playerData = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	Steam.set_leaderboard_score("Score", playerData.highScore)
	update_leaderboard()


func get_username(raw_name: String) -> String:
	var username = ""
	username = raw_name.left(16)
	if username != raw_name: username += "..."
	return username

func create_place(rank: int, name: String, score: int, par: Control) -> void:
	var newPlace = preload("res://UI/Leaderboard/Score.tscn").instance()
	par.add_child(newPlace)
	newPlace.setup(rank, name, score)

func update_leaderboard() -> void:
	if !Steam.is_init():
		var newLabel = Label.new()
		newLabel.show()
		newLabel.text = "[color=red]Can't connect to Steam.[/color]"
		globalScores.add_child(newLabel)
		return

	var playerScoreGlobal = yield(
		Steam.get_leaderboard_scores(
			"Score", -1, 5, Steam.LeaderboardDataRequest.GlobalAroundUser
		),
		"done"
	)
	for i in globalScores.get_children():
		if i.name == "Title": continue
		i.queue_free()

	for i in playerScoreGlobal:
		create_place(
			i.global_rank,
			get_username(i.persona_name),
			i.score,
			globalScores
		)


func _on_back_pressed() -> void:
	hide()

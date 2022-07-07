extends Node

var quests_ = {
	"matthews_bomb" : {
		"name" : "Matthew's Bomb",
		"player_has_bomb" : false,
		"matthew_has_bomb" : false,
		"quest_complete" : false,
	}
}


func set_quest_data(quest: String, data: String, value) -> void:
	quests_[quest][data] = value

func get_quest_data(quest: String, data: String):
	return quests_[quest][data]


func start_quest(quest: String) -> void:
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	questNotice.start_anim(true, tr(quests_[quest].name))


func end_quest(quest: String) -> void:
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	questNotice.start_anim(false, tr(quests_[quest].name))

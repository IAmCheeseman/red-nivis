extends Node

var quests_ = {
	"matthews_bomb" : {
		"player_has_bomb" : false,
		"matthew_has_bomb" : false,
		"quest_complete" : false,
	}
}


func set_quest_data(quest: String, data: String, value) -> void:
	quests_[quest][data] = value

func get_quest_data(quest: String, data: String):
	return quests_[quest][data]

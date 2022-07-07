extends Node

var quests_ = {
	"matthews_bomb" : {
		"name" : "Matthew's Bomb",
		"player_has_bomb" : false,
		"matthew_has_bomb" : false,
		"quest_complete" : false,
	}
}

var activeQuests := []
var completedQuests := []

func find_quest_(questId) -> Quest:
	for i in activeQuests:
		if questId == i.id:
			return i
	return null


func is_quest_active(questId: String) -> bool:
	return find_quest_(questId) != null


func increment_quest_counter(questId: String, amt:int=1) -> void:
	var quest = find_quest_(questId)
	assert(quest != null)
	
	quest.counter += amt
	if quest.counter >= quest.targetCount:
		complete_quest(questId)


func complete_quest(questId: String) -> void:
	var quest = find_quest_(questId)
	assert(quest != null)
	quest.completed = true


func is_quest_complete(questId: String) -> bool:
	var quest = find_quest_(questId)
	assert(quest != null)
	return quest.completed


func is_quest_handed_in(questId: String) -> bool:
	var quest = find_quest_(questId)
	assert(quest != null)
	return quest.handedIn


func get_quest_data(quest: String, data: String):
	return quests_[quest][data]


func start_quest(quest: Quest) -> void:
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	questNotice.start_anim(true, tr(quest.name))
	
	activeQuests.append(quest)


func hand_in_quest(questId: String) -> void:
	var quest = find_quest_(questId)
	assert(quest != null)
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	questNotice.start_anim(false, tr(quest.name))
	
	quest.handedIn = true
	
	activeQuests.erase(quest)
	completedQuests.append(quest)

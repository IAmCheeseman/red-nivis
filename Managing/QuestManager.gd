extends Node

var quests_ = {
	"matthews_bomb" : {
		"name" : "Matthew's Bomb",
		"player_has_bomb" : false,
		"matthew_has_bomb" : false,
		"quest_complete" : false,
	},
	"joshs_skeleton" : {
		"name" : "Josh's Skeleton",
		"player_has_skeleton" : false,
		"josh_has_skeleton" : false,
		"quest_complete" : false,
	},
}

var activeQuests := []
var completedQuests := []

func _find_quest(questId) -> Quest:
	for i in activeQuests:
		if questId == i.id:
			return i
	return null


func is_quest_active(questId: String) -> bool:
	return _find_quest(questId) != null


func increment_quest_counter(questId: String, amt:int=1) -> void:
	var quest = _find_quest(questId)
	assert(quest != null)
	
	quest.counter += amt
	if quest.counter >= quest.targetCount:
		complete_quest(questId)


func complete_quest(questId: String) -> void:
	var quest = _find_quest(questId)
	if quest == null:
		start_quest(questId)
		quest = _find_quest(questId)
	quest.completed = true


func is_quest_complete(questId: String) -> bool:
	var quest = _find_quest(questId)
	assert(quest != null)
	return quest.completed


func is_quest_handed_in(questId: String) -> bool:
	var quest = _find_quest(questId)
	assert(quest != null)
	return quest.handedIn


func start_quest(questId: String) -> void:
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	
	var quest = QuestMap.QUESTS[questId]
	
	questNotice.start_anim(true, tr(quest.name))
	
	activeQuests.append(quest)


func hand_in_quest(questId: String) -> void:
	var quest = _find_quest(questId)
	assert(quest != null)
	var questNotice = preload("res://Items/QuestItems/QuestNotice.tscn").instance()
	add_child(questNotice)
	questNotice.start_anim(false, tr(quest.name))
	
	quest.handedIn = true
	
	activeQuests.erase(quest)
	completedQuests.append(quest)

extends Control

onready var quests = find_node("Quests")


func _ready() -> void:
	for i in QuestManager.activeQuests:
		var label = Label.new()
		label.text = i.name
		quests.add_child(label)

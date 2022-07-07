extends RigidBody2D

onready var anim = $AnimationPlayer

export var relatedQuest := ""
export var questVariable := ""
export var boolSetTo := true
export var inc := 0



func _on_interaction() -> void:
	var currentQuestValue = QuestManager.get_quest_data(relatedQuest, questVariable)
	match typeof(currentQuestValue):
		TYPE_BOOL:
			QuestManager.complete_quest(
				relatedQuest
			)
		TYPE_INT:
			QuestManager.set_quest_data(
				relatedQuest, questVariable,
				currentQuestValue + inc
			)
		_:
			push_error("ERR: Not int or bool.")
	anim.play("Disappear")

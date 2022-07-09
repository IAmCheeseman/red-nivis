extends RigidBody2D

onready var anim = $AnimationPlayer

export var relatedQuest := ""
export var complete := true
export var inc := 0



func _on_interaction() -> void:
	if complete:
		QuestManager.complete_quest(relatedQuest)
	if inc != 0:
		QuestManager.increment_quest_counter(relatedQuest, inc)
	anim.play("Disappear")

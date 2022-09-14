extends "res://Entities/NPC/NPC.gd"


func start_quest() -> void:
	if defaultDialog == "Distress":
		QuestManager.start_quest("joshs_skeleton")
		return


func _on_start_talking() -> void:
	if QuestManager.is_quest_active("joshs_skeleton"):
		defaultDialog = "CheckIn"
	else:
		return
	if  QuestManager.is_quest_complete("joshs_skeleton"):
		defaultDialog = "HandIn"
		idleAnim = "DefaultSkele"


func _on_dialog_timer_done(currentDialog):
	if currentDialog == 3:
		yield(TempTimer.timer(self, 1.25), "timeout")
		QuestManager.hand_in_quest("joshs_skeleton")

extends CanvasLayer

onready var anim = $AnimationPlayer
onready var nameLabel = find_node("Name")

func start_anim(gettingQuest: bool, questName: String) -> void:
	nameLabel.text = " " + questName
	if gettingQuest:
		anim.play("Start")
		return
	anim.play("Done")

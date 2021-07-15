extends Node2D

enum Signals {DONE}

onready var sprite = $ScaleHelper/Sprite

export var talkSpeed = .05
export var dialogs:PoolStringArray = []
export var snapPos:Vector2

var player = null


func start_dialog(setDialog:String=""):
	var dialog
	if setDialog == "":
		dialog = Dialogic.start(dialogs[rand_range(0, dialogs.size())])
	else:
		dialog = Dialogic.start(setDialog)
	add_child(dialog)
	dialog.connect("timeline_end", self, "_on_dialog_finished")


func _input(event):
	if Input.is_action_just_pressed("interact") and player:
		if !player.lockMovement and player.is_on_floor():
			player.lockMovement = true
			player.global_position = global_position+snapPos
			start_dialog()


func _on_dialog_finished(timeline:String):
	player.lockMovement = false
	player = null


func _on_talk_zone_entered(area):
	if area.is_in_group("player"):
		player = area.get_parent()






extends Node2D

onready var sprite = $ScaleHelper/Sprite
onready var shadow = $ScaleHelper/Shadow
onready var dialog = $Dialog
onready var dialogBox = $Label
onready var dialogAdvanceTimer = $DialogAdvanceTimer

export var talkSpeed = .05

var currentDialog = 1

func _ready():
	start_dialog()


func _process(_delta):
	shadow.frame = sprite.frame


func start_dialog(setDialog:int = -1):
	# Resetting the dialog box
	dialogBox.visible_characters = 0
	currentDialog = 1
	# Selecting the dialog to play
	if setDialog == -1:
		dialog.dialog.shuffle()
		dialogBox.text = dialog.dialog[0]["dialog"+str(currentDialog)]
	else:
		dialogBox.text = dialog.dialog[setDialog]["dialog"+str(currentDialog)]
	# Starting the dialog
	dialogAdvanceTimer.start(talkSpeed)


func advance_dialog():
	dialogBox.visible_characters += 1
	dialogBox.rect_position.x = -dialogBox.rect_size.x/2
	dialogAdvanceTimer.start(talkSpeed)

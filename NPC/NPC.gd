extends Node2D

onready var sprite = $ScaleHelper/Sprite
onready var shadow = $ScaleHelper/Shadow
onready var dialog = $Dialog
onready var dialogBox = $Label
onready var dialogAdvanceTimer = $DialogAdvanceTimer
onready var optionContainer = $DialogOptions/Options

export var talkSpeed = .05
export var snapPos:Vector2

var dialogOptionButton = preload("res://UI/DialogOption.tscn")
var currentDialogIndex = 1
var currentDialog : Dictionary
var inDialog = false
var player = null

var responses = {}


func _process(_delta):
	shadow.frame = sprite.frame


func start_dialog(setDialog:int = -1):
	if player:
		player.lockMovement = true
		player.position = position+snapPos

		inDialog = true

		# Resetting the dialog box
		dialogBox.visible_characters = 0
		currentDialogIndex = 1
		# Selecting the dialog to play
		if setDialog == -1:
			dialog.dialog.shuffle()
			currentDialog = dialog.dialog[0]
			var selectedDialog = dialog.dialog[0]["dialog"+str(currentDialogIndex)]
			# If it has options to choose, then give those options.
			if selectedDialog is Dictionary:
				set_options(selectedDialog)
			else:
				dialogBox.text = selectedDialog
		else:
			dialogBox.text = dialog.dialog[setDialog]["dialog"+str(currentDialogIndex)]
		# Starting the dialog
		dialogAdvanceTimer.start(talkSpeed)


func advance_dialog():
	dialogBox.visible_characters += 1
	dialogBox.rect_position.x = -dialogBox.rect_size.x/2
	dialogAdvanceTimer.start(talkSpeed)


func set_options(selectedDialog:Dictionary):
	dialogBox.text = selectedDialog.text

	var dialogOptions = selectedDialog.choice.choices
	var dialogResponses = selectedDialog.choice.responses

	for choice in dialogOptions:
		responses[choice] = dialogResponses[choice]

		var newOption = dialogOptionButton.instance()
		newOption.set_option(choice)
		optionContainer.add_child(newOption)
		newOption.connect("optionSelected", self, "advance_current_dialog")


func advance_current_dialog(option=null):
	for c in optionContainer.get_children():
		c.queue_free()

	dialogBox.visible_characters = 0
	currentDialogIndex += 1
	if option:
		currentDialog = responses[option]
		dialogBox.text = responses[option]["dialog"+str(currentDialogIndex)]
		# Starting the dialog
		dialogAdvanceTimer.start(talkSpeed)
	else:
		if !currentDialog.has("dialog"+str(currentDialogIndex)):
			exit_dialog()
			return
		var newDialog = currentDialog["dialog"+str(currentDialogIndex)]
		if newDialog is Dictionary:
			set_options(newDialog)
			dialogAdvanceTimer.start()
			return

		dialogBox.text = currentDialog["dialog"+str(currentDialogIndex)]
	dialogAdvanceTimer.start()


func _input(event):
	if player and Input.is_action_just_pressed("interact") and !inDialog:
		start_dialog()
	if inDialog and Input.is_action_just_pressed("swap_weapons"):
		advance_current_dialog()


func exit_dialog():
	dialogBox.visible_characters = 0
	inDialog = false
	player.lockMovement = false
	player.vel = Vector2.ZERO
	dialogAdvanceTimer.stop()


func _on_talk_zone_entered(area):
	if area.is_in_group("player"):
		player = area.get_parent()






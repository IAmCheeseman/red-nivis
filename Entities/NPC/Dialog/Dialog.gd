extends Control


export var dialog:Resource
export var pointerOffset := 15
export var advanceTime := 3.0

onready var text = $Text
onready var background = $Background
onready var pointer = $Pointer
onready var advanceTimer = $AdvanceTimer
onready var charIncTimer = $CharIncTimer
onready var speakSound = $Bleep

#var dialogIst:AnimationPlayer
var currentDialogID := ""
var targetText := ""
var charsShown = 0
var currentDialog = 1
var finished = false

signal done


func start_dialog(interaction:String="Introduction") -> void:
#	set_dialog()
	currentDialog = 0
	currentDialogID = interaction
	
	text.text = ""
	reposition_bg()
	
	increment_text()
	charIncTimer.start()


func stop_dialog() -> void:
	currentDialogID = ""


#func set_dialog() -> void:
#	if dialogIst:
#		return
#	dialogIst = dialog.instance()
#	add_child(dialogIst)


func reposition_bg() -> void:
	var font:Font = text.get_font("normal_font")
	
	var size := font.get_string_size(text.text)
	# Background
	
	# 16 just makes sure that it can completely fit the thing
	background.rect_size.x = size.x + 16 
	background.rect_position.x = -background.rect_size.x*.666
	
	# Pointer
	pointer.position.x = 0
	
	# Label
	text.rect_size.x = background.rect_size.x
	text.rect_position.x = background.rect_position.x


func add_center_tags(string:String) -> String:
	return "[center]" + string + "[/center]"


func increment_char() -> void:
	if finished: return
	if !currentDialogID: return
	
	text.bbcode_text = targetText
	if rand_range(0, 1) < .666:
		speakSound.play()
	var testText = add_center_tags(text.text)
	text.bbcode_text = add_center_tags(text.text.left(charsShown))
	
	if text.bbcode_text.length() == testText.length():
		text.bbcode_text = add_center_tags(targetText)
		finished = true
		advanceTimer.start(advanceTime)
		return
	
	charsShown += 1
	reposition_bg()
	
	charIncTimer.start(rand_range(.025, .1))
 

func increment_text() -> void:
	# Resetting 
	finished = false
	charsShown = 0
	
	var currentInteraction = dialog.get_interaction(currentDialogID)
	currentDialog += 1
	
	# Finishing
	if currentDialog >= currentInteraction.size():
		hide()
		emit_signal("done")
		return
	
	# Starting
	targetText = currentInteraction[currentDialog]
	charIncTimer.start()


